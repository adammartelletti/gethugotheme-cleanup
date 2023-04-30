Add this script within your Big Spring theme root directory and make sure to give it executable permissions with `chmod +x cleanup_big_spring.sh`.

To run the script, simply execute `./cleanup_big_spring.sh` in your terminal.

Please note that this script assumes that you are running it from the root directory of your BigSpring Hugo theme.

If you need to run it from a different location, you should modify the paths accordingly.

## Process 
* Add shortcode directory to layouts
* Remove old example site directory
* Remove menu config files for German and Chinese languages
* Remove Chinese and German content directories
* Remove forestry directory
* Override the language.toml file with the English language configuration
* Update the hasCJKLanguage setting in the config.toml file
* Update the default image quality setting in the config.toml file (100 to 75)
* Update the default disqusShortname setting in the config.toml file (turns of disqus)
* Update font_primary and font_secondary values in the config.toml file (Lato)
* Update preloader value in the params.toml file (Addes PNG, JPG, SVG, GIF) to the image pre-loader
* Run Hugo build command
* If the Hugo build is successful, then the cleanup is complete


## Error handling and reverting changes
1. This script creates backups of the necessary files before making changes.
2. If the Hugo build fails, it calls the revert_changes function to restore the original files from the backups.
3. The remove_backup function to remove the backup files and calls it when the cleanup is successful.
