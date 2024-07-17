#!/bin/bash

THEME_SOURCE=https://github.com/stepanzubkov/where-is-my-sddm-theme.git
if [[ -n $USE_QT5 ]]; then
    THEME_DIR=where_is_my_sddm_theme_qt5
else
    THEME_DIR=where_is_my_sddm_theme
fi
SDDM_THEMES_DIR=/usr/share/sddm/themes/
SDDM_CONFIG_PATH=/etc/sddm.conf.d/kde_settings.conf:/etc/sddm.conf

if [[ -z $THEME_SOURCE ]]; then
    echo -e "\e[31;02mImproperly configured! THEME_SOURCE should be set!\e[0m"
    exit 1
fi

if [[ -z $THEME_DIR ]]; then
    echo -e "\e[31;02mImproperly configured! THEME_DIR should be set!\e[0m"
    exit 1
fi

if [[ ! -d $SDDM_THEMES_DIR ]]; then 
    echo -e "\e[31;02m$SDDM_THEMES_DIR doesn't exist! Please, create it manually or edit SDDM_THEMES_DIR variable"
    exit 1
fi

git clone $THEME_SOURCE .theme_temp || (echo -e "\e31;02mFailed to fetch git repo at $THEME_SOURCE.\e[0m" && exit 1)

if [[ ! -d .theme_temp/$THEME_DIR ]]; then
    echo -e "\e[31;02m$THEME_DIR is not found at $THEME_SOURCE!\e[0m"
    rm -rf .theme_temp
    exit 1
fi

cp -rv .theme_temp/$THEME_DIR $SDDM_THEMES_DIR || (echo -e "\e31;02mFailed to copy theme to $SDDM_THEMES_DIR!\e[0m" && rm -rf .theme_temp && exit 1)
echo -e "\e[32;02mTheme successfully installed!\e[0m"
rm -rf .theme_temp

if [[ $1 == "current" ]]; then
    for file in `echo "$SDDM_CONFIG_PATH" | tr ':' '\n'`; do
        if [[ -f $file ]]; then
            sed -i "s/Current=.*/Current=$THEME_DIR/" $file || (echo -e "\e[31;02mFailed to edit $file.\e[0m" && exit 1)
            exit 0
        fi
    done
    echo -e "\e[33;02mFailed to set theme as current. Try to edit sddm configuration manually.\e[0m"
fi
