#!/bin/bash

# Backup function
backup() {
  cp "$1" "$1.bak"
}

# Remove backup function
remove_backup() {
  [ -f "$1.bak" ] && rm -f "$1.bak"
}

# Revert function
revert_changes() {
  echo "Reverting changes..."
  [ -f config/_default/languages.toml.bak ] && mv config/_default/languages.toml.bak config/_default/languages.toml
  [ -f config/_default/config.toml.bak ] && mv config/_default/config.toml.bak config/_default/config.toml
  [ -f config.toml.bak ] && mv config.toml.bak config.toml
  [ -f config/_default/params.toml.bak ] && mv config/_default/params.toml.bak config/_default/params.toml
}

# Create backups
backup config/_default/languages.toml
backup config/_default/config.toml
backup config.toml
backup config/_default/params.toml

# Add shortcode directory to layouts
mkdir -p themes/bigspring/layouts/shortcodes


# Remove old example site directory
rm -rf themes/bigspring/exampleSite

# Remove menu config files for German and Chinese languages
rm -f config/_default/menus.de.toml
rm -f config/_default/menus.zh-cn.toml

# Remove Chinese and German content directories
rm -rf content/chinese
rm -rf content/deutsch
rm -rf public/en
rm -rf public/de
rm -rf public/zh-cn

# Remove forestry directory
rm -rf themes/bigspring/.forestry
rm -rf themes/bigspring/config.toml

# Check if the languages.toml file exists
if [ ! -f "config/_default/languages.toml" ]; then
    echo "Error: languages.toml file not found"
    exit 1
fi

# Override the language.toml file with the English language configuration
cat > config/_default/languages.toml << EOL
################################### English language #####################################
[en]
languageName = "EN"
languageCode = "en-US"
contentDir = "content/english"
weight = 1
########### footer content ##########
footer_menu_left = "Company"
footer_menu_middle = "Products"
footer_menu_right = "Support"
footer_content = "Lorem ipsum dolor sit amet, consectetur elit consjat tristique eget amet."
EOL

# Check if the config.toml file exists
if [ ! -f "config/_default/config.toml" ]; then
    echo "Error: config.toml file not found"
    exit 1
fi

# Update the hasCJKLanguage setting in the config.toml file
awk 'BEGIN {updated = 0} /hasCJKLanguage/ && !updated {sub(/true/, "false"); updated = 1} {print}' config/_default/config.toml > config/_default/config.tmp && mv config/_default/config.tmp config/_default/config.toml

# Update the default image quality setting in the config.toml file
awk 'BEGIN {updated = 0} /quality =/ && !updated {sub(/100/, "75"); updated = 1} {print}' config/_default/config.toml > config/_default/config.tmp && mv config/_default/config.tmp config/_default/config.toml

# Update the default disqusShortname setting in the config.toml file
awk 'BEGIN {updated = 0} /disqusShortname =/ && !updated {sub(/themefisher-template/, ""); updated = 1} {print}' config/_default/config.toml > config/_default/config.tmp && mv config/_default/config.tmp config/_default/config.toml

# Check if the config.toml file exists
if [ ! -f "config.toml" ]; then
    echo "Error: config.toml file not found"
    exit 1
fi

# Update font_primary and font_secondary values in the config.toml file
awk '
/font_primary *=/ {sub(/= *".*"/, "= \"Lato:wght@400;700\"")}
/font_secondary *=/ {sub(/= *".*"/, "= \"Lato:wght@400;700\"")}
{print}
' config.toml > config.tmp && mv config.tmp config.toml

# Check if the params.toml file exists
if [ ! -f "config/_default/params.toml" ]; then
    echo "Error: params.toml file not found"
    exit 1
fi

# Update preloader value in the params.toml file
awk '
/preloader *=/ {sub(/= *".*"/, "= \"images/preloader.jpg, images/preloader.png, images/preloader.svg, images/preloader.gif\"")}
{print}
' config/_default/params.toml > config/_default/params.tmp && mv config/_default/params.tmp config/_default/params.toml

# Run Hugo build command
hugo -cg

# If the Hugo build is successful, then the cleanup is complete
if [ $? -eq 0 ]; then
    echo "Cleanup completed successfully."
    remove_backup config/_default/languages.toml
    remove_backup config/_default/config.toml
    remove_backup config.toml
    remove_backup config/_default/params.toml
else
    revert_changes
fi
