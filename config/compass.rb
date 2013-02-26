require 'sinatra/base'
require 'zurb-foundation'
# Require any additional compass plugins here.

project_path = Sinatra::Application.root

# HTTP paths
http_path = "/"
http_stylesheets_path = "/stylesheets"
http_images_path      = "/images"
http_javascripts_path = "/javascripts"

# File system locations
sass_dir        = File.join 'views', 'stylesheets'
css_dir         = File.join 'public', 'stylesheets'
images_dir      = File.join 'public', 'images'
javascripts_dir = File.join 'public', 'javascripts'

preferred_syntax = :sass

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass