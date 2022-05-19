# Drupal Core Development Composer Project

This is a Composer project template for developing Drupal core.

It allows:

- a clean git clone of Drupal core.
- Composer dependencies of Drupal core are installed, so Drupal can be installed
  and run as normal.
- other Composer packages you might want, such as Drush, Devel module, and Admin
  Toolbar module, can be installed too, but don't affect the composer files
  that are part of Drupal core.

## Installation

To install a Drupal project for working on Drupal core:

```
$ composer create-project joachim-n/drupal-core-development-project
```

Composer will clone Drupal core into a 'repos/drupal' directory within the
project, and then symlink that into the project when it installs Drupal core.

Once the installation is complete, you can install Drupal as normal, either with
`drush si` or with the web UI.

## Limitations

During some Composer commands you may see multiple copies of this error message:

> Could not scan for classes inside [Drupal class filename].

These are harmless and can be ignored.

## Developing Drupal core

You can use the Drupal core git clone at 'repos/drupal/' in any way you like:
create feature branches, clone from drupal.org issue forks, and so on. Changes
you make to files in the git clone affect the project, since the git clone is
symlinked into it.

### Managing the Composer project

You can install any Composer packages you like, including Drupal contrib
modules, without affecting the git clone of Drupal core. To work with Composer,
you need to be in the root directory of the project.

Changes to the git clone's composer.json will be taken into account by Composer.
So for example, if pulling from the main branch of Drupal core changes Composer
dependencies, and in particular if you change to a different core major or minor
branch, you should run `composer update` on the project to install these.

### Running tests

The following are required to run tests.

#### PHPUnit configuration

The simplest way to run tests with this setup is to put the phpunit.xml file in
the project root and then run tests from there:

$ vendor/bin/phpunit web/core/PATH-TO-TEST-FILE/TestFile.php

To set this up, copy Drupal core's sample phpunit.xml file to the project root:

$ cp web/core/phpunit.xml.dist phpunit.xml

Then change the `bootstrap` attribute so the path is correct:

```
<phpunit bootstrap="web/core/tests/bootstrap.php"
```

## Technical details

The rest of this document is gory technical details you only need to know if
you're working on this project template or debugging it.

### How it works

The composer.json at the project root uses a Composer path repository so that
when the drupal/drupal package is installed, it's symlinked in from the Drupal
core git clone, at the branch that the clone has checked out.

Drupal core itself defines path repositories in its top-level composer.json.
These need to be overridden in the project root composer.json so they point to
inside the Drupal core git clone.

Additionally, the paths to the drupal/core-recommended and drupal/core-dev
packages are defined as path repositories, so that the package versions which
are fixed in those metapackages are respected in the project. This means the
same versions are installed as if installing Composer packages on a plain git
clone of Drupal core.

### Manual Installation

Clone the repository for this template into, say, 'drupal-dev'.

```
$ cd drupal-dev

# Create a folder in which to store git clones, which Composer will symlink in.
$ mkdir repos
$ cd repos

# Clone Drupal core, to whatever branch you like.
$ git clone --branch 9.2.x https://git.drupalcode.org/project/drupal.git

# Go back to the project root.
$ cd ..

# Install packages with Composer.
$ composer install
```

The Drupal core git clone will be clean apart from:

```
	sites/default/settings.php
	vendor
```

Since it doesn't have a .gitignore at the top level, you can add one to ignore
those files if you like.

### Project template development installation

To test how Composer creates a new project from the template, you need a git
clone of the template repository.

In a separate location, do:

```
$ composer create-project joachim-n/drupal-core-development-project NEW_PROJECT_DIRECTORY --stability=dev --repository='{"url":"/path/to/git/clone/of/project/template/","type":"vcs"}'
```

### Workarounds

Several workarounds are necessary to make Drupal core work correctly when
symlinked into the project. These are all taken care of by Composer scripts
during installation. Details are below.

Most if not all of these will no longer be needed once
https://www.drupal.org/project/drupal/issues/1792310 is fixed.

#### Vendor folder

The vendor folder has to be symlinked into the Drupal core repository, because
otherwise code in core that expects to find a Composer autoloader fails.

This is done by a Composer script after initial installation. The manual command
is:

```
ln -s ../../vendor ./repos/drupal/vendor
```

#### App root files patches

The index.php and update.php scaffold files have to be patched after they have
been copied to web/index.php, because otherwise DrupalKernel guesses the Drupal
app root as incorrectly being inside the Drupal core git clone, which means it
can't find the settings.php file.

This is done by a Composer script after initial installation. The manual
commands are:

```
cd web && patch -p1 <../scaffold/scaffold-patch-index-php.patch
cd web && patch -p1 <../scaffold/scaffold-patch-update-php.patch
```

See https://www.drupal.org/project/drupal/issues/3188703 for more detail.

#### Drush rebuild command

The Drush cache:rebuild command does not work correctly if contrib modules are
present, because it calls drupal_rebuild() which lets DrupalKernel guess the
app root incorrectly.

This project template contains a /drush folder which has a command class which
replaces that command with custom code to correctly handle the app root.

#### Simpletest folder

When running browser tests, the initial setup of Drupal in
FunctionalTestSetupTrait::prepareEnvironment() creates a site folder using the
real file locations with symlinks resolved, thus
`repos/drupal/sites/simpletest`, but during the request to the test site, Drupal
looks in `/web/sites/simpletest`.

Additionally, the HTML files output from Browser tests are written into the
Drupal core git clone, and so the URLs shown in PHPUnit output are incorrect.

The fix for both of these is to create the simpletest site folder in the web
root and symlink it into the Drupal core git clone.

This is done by a Composer script after initial installation. The manual command
is:

```
mkdir -p web/sites/simpletest
ln -s ../../../web/sites/simpletest repos/drupal/sites
```

#### Autoload of Drupal composer testing classes

Drupal's /composer folder is not symlinked and therefore isn't visible to
Composer. It's needed for some tests, and so is declared as an autoload
location.
