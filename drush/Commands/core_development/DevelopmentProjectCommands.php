<?php

namespace Drush\Commands\core_development;

use Consolidation\AnnotatedCommand\AnnotationData;
use Drupal\Core\DrupalKernel;
use Drupal\Core\Site\Settings;
use Drush\Commands\core\CacheCommands;
use Drush\Drush;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\ArgvInput;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\HttpFoundation\Request;

/**
 * Replaces the cache:rebuild command to correctly work with symlinked Drupal.
 *
 * This prevents contrib modules from vanishing when the cache:rebuild command
 * is run.
 *
 * For maintainability, changes from the original are marked 'CHANGE'.
 */
class DevelopmentProjectCommands extends CacheCommands {

  /**
   * @hook replace-command cache:rebuild
   */
  public function rebuild($options = ['cache-clear' => true]) {
    if (!$options['cache-clear']) {
      $this->logger()->info(dt("Skipping cache-clear operation due to --no-cache-clear option."));
      return true;
    }

    // CHANGE: Get the app root ourselves instead of using DRUPAL_ROOT.
    $app_root = $this->getAppRoot();
    chdir($this->getAppRoot());

    // We no longer clear APC and similar caches as they are useless on CLI.
    // See https://github.com/drush-ops/drush/pull/2450

    $autoloader = $this->loadDrupalAutoloader(DRUPAL_ROOT);
    require_once DRUSH_DRUPAL_CORE . '/includes/utility.inc';

    $request = Drush::bootstrap()->getRequest();
    DrupalKernel::bootEnvironment();

    // Avoid 'Only variables should be passed by reference'
    // CHANGE: Don't use DRUPAL_ROOT.
    $root = $app_root;
    $site_path = DrupalKernel::findSitePath($request);
    Settings::initialize($root, $site_path, $autoloader);

    // drupal_rebuild() calls drupal_flush_all_caches() itself, so we don't do it manually.
    // CHANGE: call our own version of drupal_rebuild().
    $this->drupal_rebuild($autoloader, $request);
    $this->logger()->success(dt('Cache rebuild complete.'));
  }

  /**
   * Replacement for drupal_rebuild().
   *
   * This passes the app root to DrupalKernel.
   */
  function drupal_rebuild($class_loader, Request $request) {
    // Remove Drupal's error and exception handlers; they rely on a working
    // service container and other subsystems and will only cause a fatal error
    // that hides the actual error.
    restore_error_handler();
    restore_exception_handler();

    // Invalidate the container.
    // Bootstrap up to where caches exist and clear them.
    // CHANGE: Pass the correct app root to DrupalKernel.
    $kernel = new DrupalKernel('prod', $class_loader, TRUE, $this->getAppRoot());
    $kernel->setSitePath(DrupalKernel::findSitePath($request));
    $kernel->invalidateContainer();
    $kernel->boot();
    $kernel->preHandle($request);
    // Ensure our request includes the session if appropriate.
    if (PHP_SAPI !== 'cli') {
      $request->setSession($kernel->getContainer()->get('session'));
    }

    drupal_flush_all_caches($kernel);

    // Disable recording of cached pages.
    \Drupal::service('page_cache_kill_switch')->trigger();

    // Restore Drupal's error and exception handlers.
    // @see \Drupal\Core\DrupalKernel::boot()
    set_error_handler('_drupal_error_handler');
    set_exception_handler('_drupal_exception_handler');
  }

  /**
   * Gets the app root.
   *
   * @return string
   *   The app root.
   */
  protected function getAppRoot(): string {
    // This core belongs to the project template, so we can hardcode the
    // location of this file relative to the project root, and the scaffold
    // location defined in the project's composer.json.
    return dirname(__DIR__, 3) . '/web';
  }

}
