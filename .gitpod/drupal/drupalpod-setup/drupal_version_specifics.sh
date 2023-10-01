#!/usr/bin/env bash

# Adding support for composer-drupal-lenient - https://packagist.org/packages/mglaman/composer-drupal-lenient
if [[ "$DP_CORE_VERSION" == 10* ]]; then
    if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
        export COMPOSER_DRUPAL_LENIENT=mglaman/composer-drupal-lenient
    else
        export COMPOSER_DRUPAL_LENIENT=''
    fi
fi

# Adding support for composer-drupal-lenient - https://packagist.org/packages/mglaman/composer-drupal-lenient
if [[ "$DP_CORE_VERSION" == 11* ]]; then
    # admin_toolbar and devel are not compatible yet with Drupal 11
    unset DP_EXTRA_ADMIN_TOOLBAR
    unset DP_EXTRA_DEVEL
    if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
        export COMPOSER_DRUPAL_LENIENT=mglaman/composer-drupal-lenient
    else
        export COMPOSER_DRUPAL_LENIENT=''
    fi
fi
