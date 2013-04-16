require 'sinatra/base'
require 'zurb-foundation'

project_path = Sinatra::Application.root

# HTTP paths
http_path = "/"
http_stylesheets_path = "/assets/stylesheets"
http_images_path      = "/assets/images"
http_javascripts_path = "/assets/javascripts"

# File system locations
sass_dir        = File.join "assets", "sass"
css_dir         = File.join "assets", "stylesheets"
images_dir      = File.join "assets", "images"
javascripts_dir = File.join "assets", "javascripts"

preferred_syntax = :sass

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style = :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
