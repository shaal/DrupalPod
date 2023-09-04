# File Structure

The drupalpod-setup.sh script can be divided into several logical sections based on the tasks it performs. Here are some potential divisions:

1. Environment Setup: This section sets up the environment variables and checks for certain conditions. It includes the loading of default environment variables, setting up the default setup during the prebuild process, and checking if additional modules should be installed.

2. Composer Support: This section adds support for composer-drupal-lenient based on the Drupal core version.

3. PHP Version Setup: This section sets up the PHP version for Drupal 10.0.x.

4. Drupal Setup: This section checks if the setup has already run once and if no special setup is set by the DrupalPod extension. If not, it performs a series of setup tasks, including adding git.drupal.org to known hosts, ignoring specific directories during Drupal core development, and getting the required repo ready.

5. Drupal Installation: This section handles the installation of Drupal, including enabling extra modules, setting the default admin theme, enabling the requested module or theme, and updating the database if working on core.

6. Post-Installation: This section takes a snapshot of the database, saves a file to mark the workspace as already initiated, and measures the script time.

7. Cleanup: This section starts DDEV if the setup has already run once, opens an internal preview browser with the current website, and removes the ready-made-envs directory to minimize storage of the workspace.

Each of these sections could potentially be extracted into its own function or even its own script, depending on how modular you want your code to be.
