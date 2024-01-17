# Where is my SDDM theme?
*:eyes: That feeling when your SDDM theme suddenly disappeared...*

The most minimalistic SDDM theme among all themes. Only black screen and password input field. Nothing extra, right? Even when you enter wrong password theme will show only red border around your screen. To login, just press `<Enter>` key.

**Warning:** This theme is completed. This is not raw version. Yes, this theme is strange. If you do not like this theme, pay attention to [other theme](https://github.com/stepanzubkov/sddm-zust)

*Take a look*

- With default black background
![screenshot](https://github.com/stepanzubkov/where-is-my-sddm-theme/blob/main/where_is_my_sddm_theme/screenshot.png?raw=true)

- With image background
![Screenshot_20230511_211739](https://github.com/raihanadf/where-is-my-sddm/assets/83695097/36880c07-c4d2-4056-b3b3-243b4043f475)

# Keymaps

`F2` or `Alt+u` - cycle select next user

`Ctrl+F2` or `Alt+Ctrl+u` - cycle select prev user

`F3` or `Alt+s` - cycle select next session

`Ctrl+F3` or `Alt+Ctrl+s` - cycle select prev session

`F10` - Suspend.

`F11` - Poweroff.

`F12` - Reboot.

`F1` - Show help message.

# Installation

## With script

This script is working only in kde now.

This script should be run with **sudo**!

Run `./install.sh` to install theme to sddm themes directory.
Run `./install.sh current` to install theme and set it as current theme.

## From KDE store
You can find product page on [pling](https://www.pling.com/p/2011322/)
### On KDE
1. Open System settings
2. Choose Start and finish/Log in (SDDM)
3. Click on "...", then "Download SDDM theme..."
4. Search "Where is my sddm theme?" theme
5. Install
6. Activate

### On other DEs/WMs
1. Open [link](https://www.pling.com/p/2011322/)
2. Click on "Install"
3. Unzip downloaded archive
4. Copy given folder to /usr/share/sddm/themes (`sudo cp -r where_is_my_sddm_theme/ /usr/share/sddm/themes`)
5. Open /etc/sddm.conf
6. Change line `Current=...` to `Current=where_is_my_sddm_theme`

## From source
1. Clone repo
2. [On other DEs/WMs](#on-other-deswms) (steps 4-6)

# Configuration
In `theme.conf` file you can find theme configuration.

Awailable settings:

**passwordCharacter** - Character, that used for password security mask. <br>
**background** - Background, used for wallpaper (optional). <br>
**backgroundFill** - Background Layer, used for layering the background. <br>
**backgroundMode** - One of *aspect*, *fill*, *tile*, *none*. <br>
**cursorColor** - Manages color of cursor in password input field. May be one of:
 - `random` (default) - Changes cursor color to random color after every entered char.
 - `constantRandom` - like `random`, but changes cursor color once, at theme loading.
 - `#<hex color>` - Hex rgb color.

**passwordFontSize** - Font size for password input field. <br>
**usersFontSize** - Font size for users choose element. <br>
**sessionsFontSize** - Font size for sessions choose element.

## Disable virtual keyboard

You can disable virtual keyboard by setting line `InputMethod=qtvirtualkeyboard`
to `InputMethod=` in sddm config file. SDDM config is located in `/etc/sddm.conf`
(or `/etc/sddm.conf.d/kde_settings.conf`)

# Contributions

Contributions are welcome! Create Issues and PRs

[![Stargazers repo roster for @stepanzubkov/sddm-zust](https://reporoster.com/stars/stepanzubkov/where-is-my-sddm-theme)](https://github.com/stepanzubkov/where-is-my-sddm-theme/stargazers)

[![Forkers repo roster for @stepanzubkov/where-is-my-sddm-theme](https://reporoster.com/forks/stepanzubkov/where-is-my-sddm-theme)](https://github.com/stepanzubkov/where-is-my-sddm-theme/network/members)
