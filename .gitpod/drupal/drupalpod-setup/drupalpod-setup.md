# File Structure

The drupalpod-setup.sh script can be divided into several logical sections based on the tasks it performs. Here are some potential divisions:

1. Environment Setup: This section sets up the environment variables and checks for certain conditions. It includes the loading of default environment variables, setting up the default setup during the prebuild process, and checking if additional modules should be installed.

1. Composer Support: This section adds support for composer-drupal-lenient based on the Drupal core version.

1. Drupal Setup: This section checks if the setup has already run once and if no special setup is set by the DrupalPod extension. If not, it performs a series of setup tasks, including adding git.drupal.org to known hosts, ignoring specific directories during Drupal core development, and getting the required repo ready.

1. Drupal Installation: This section handles the installation of Drupal, including enabling extra modules, setting the default admin theme, enabling the requested module or theme, and updating the database if working on core.

1. Post-Installation: This section takes a snapshot of the database, saves a file to mark the workspace as already initiated, and measures the script time.

1. Sourced Files:
   - `setup_env.sh`: Sets up default environment variables based on a `.env` file.
   - `install_modules.sh`: Sets environment variables for installing additional modules in Drupal.
   - `drupal_version_specifics.sh`: Adds support for the `composer-drupal-lenient` package based on the Drupal core version.
