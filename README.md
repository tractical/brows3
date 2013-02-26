# BrowS3
BrowS3 is a web interface to easily browse your Amazon S3 files.

## Project dependencies
- Ruby 1.9.3p125
- Sinatra 1.3.3
- RubyTree 0.8.3
- fog 1.8.0
- aws-sdk 1.7.1

## Setup Development Environment
1. Install Ruby. You can use [rbenv](https://github.com/sstephenson/rbenv) or
any [other method](http://www.ruby-lang.org/en/downloads/) you prefer.

2. Clone the repository

    $ git clone git@github.com:tractical/s3_browser.git

3. Run bundle to install the required gems.

    $ bundle install

4. Create your configuration settings file. You can find an example at
`config/config.yml.example`

    $ touch /config/config.yml

5. Run the application.

    $ rackup config.ru

## Deployment
Brows3 is ready for deploy to [Heroku](http://www.heroku.com/).

1. If you don't have a Heroku account follow their
[quickstart](https://devcenter.heroku.com/articles/quickstart)
guide to create it and get ready to
[deploy a Ruby application](https://devcenter.heroku.com/articles/ruby).

2. For a Rack app (such as ours) we need to
[declare a process type](https://devcenter.heroku.com/articles/ruby#declare-process-types-with-procfile)
with Procfile.

    # Procfile
    web: bundle exec rackup config.ru -p $PORT

3. Finally create a custom
[session secret](http://www.sinatrarb.com/intro#Using%20Sessions) to sign your
session data. You can use the same one defined in your `config.yml` local settings
file.

    $ heroku config:add SESSION_SECRET=yoursessionsecretkey

4. You are ready to go! :)