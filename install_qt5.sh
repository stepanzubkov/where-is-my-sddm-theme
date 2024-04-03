#!/bin/bash

cp -r where_is_my_sddm_theme_qt5/ /usr/share/sddm/themes/
echo "Successfully installed!"

if [[ $1 == "current" ]]; then
    sed -i 's/Current=.*/Current=where_is_my_sddm_theme_qt5/' /etc/sddm.conf.d/kde_settings.conf
fi
