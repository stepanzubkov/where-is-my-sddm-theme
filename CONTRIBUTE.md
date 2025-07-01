# How to contribute?

1. The easiest one: create theme configuration based on `theme.conf` file. Just edit it and send it via pull request.

2. Fixing bugs. If you encountered a bug, send issue. You can also try to fix already encountered bugs.

3. Adding new feature. You can add new interesting feature, that will fit in minimalist theme design. 
Especially, you can use config file to add more customization for the theme.

# How to send an issue?

Issue format is free. Just describe your bug/enhancement in detail, with all necessary information.

# How to create theme customization?

1. Edit `theme.conf` file and move it to `example_configs` directory in theme directory.

2. Make screenshot of your customization. Run `sddm-greeter-qt6 --test-mode --theme .` inside theme directory containing your config,
Or run `sddm-greeter --test-mode --theme .` for Qt5. Move this screenshot to `screentshots` directory.

3. Add your customization to README file in proper format.

4. Create pull request.

# How to add new configuration field to theme.conf?

Just add it to main `theme.conf` file in theme directory, then add it to other configurations in `example_configs` directory.

Follow [this SDDM API](https://github.com/sddm/sddm/wiki/Theming#new-explicitly-typed-api-since-sddm-020) to read this new configuraiton field to QML code.
