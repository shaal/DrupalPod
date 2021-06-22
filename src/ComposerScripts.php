<?php

namespace DrupalGitCloneProject;

use Composer\Script\Event;

/**
 * Provides Composer scripts for setting up Drupal from a git clone.
 */
class ComposerScripts {

  /**
   * Clones Drupal core if it's not already in repos/drupal.
   *
   * Script for the 'post-root-package-install' event.
   */
  public static function postRootPackageInstall(Event $event) {
    if (!file_exists('repos/drupal/.git')) {
      $io = $event->getIO();

      if (!file_exists('repos')) {
        $io->write("Creating 'repos/' directory within the project directory.");

        mkdir('repos');
      }

      $project_root = getcwd();
      chdir('repos');

      $io->write("Cloning Drupal core into 'repos/drupal'.");

      system('git clone https://git.drupalcode.org/project/drupal.git');

      // Restore the working directory to the project root.
      chdir($project_root);
    }
  }

  /**
   * Sets up files and symlinks after installation.
   *
   * See README for details.
   */
  public static function postDrupalScaffold() {
    // Development: this makes symfony var-dumper work.
    // See https://github.com/composer/composer/issues/7911
    include './vendor/symfony/var-dumper/Resources/functions/dump.php';

    // Apply a patch to the scaffold index.php file.
    // See https://www.drupal.org/project/drupal/issues/3188703
    chdir('web');
    shell_exec('patch -p1 <../scaffold/scaffold-patch-index-php.patch');

    // Symlink the top-level vendor folder into the Drupal core git repo.
    chdir('..');
    static::makeSymlink('../../vendor', 'repos/drupal/vendor');

    // Create folders for running tests.
    if (!file_exists('web/sites/simpletest')) {
      mkdir('web/sites/simpletest', 0777, TRUE);
    }
    if (!file_exists('web/sites/simpletest/browser_output')) {
      mkdir('web/sites/simpletest/browser_output', 0777, TRUE);
    }

    // Symlink the simpletest folder into the Drupal core git repo.
    static::makeSymlink('../../../web/sites/simpletest', 'repos/drupal/sites/simpletest');
  }

  /**
   * Creates a symlink if one is not already present.
   *
   * Prints a warning if the symlink exists but does not link to the correct
   * target.
   *
   * @param string $target
   *   The target to link to, as a relative path to the symlink.
   * @param string $link
   *   The new link to create.
   */
  protected static function makeSymlink($target, $link) {
    if (file_exists($link)) {
      if (!is_link($link)) {
        print("WARNING: {$link} exists already and is not a symlink.\n");
      }

      // Use realpath() on the target in case the symlink is absolute while the
      // expected target is relative.
      if (readlink($link) != $target) {
        $actual_target = readlink($link);
        print("WARNING: {$link} exists already and is incorrectly symlinked to {$actual_target} instead of {$target}.\n");
      }
    }
    else {
      symlink($target, $link);
    }
  }

}