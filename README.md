# BrowS3
[BrowS3](https://www.brows3.it/) is a Sinatra web application that allows you to
easily browse your Amazon S3 files. You can either access it on
https://www.brows3.it/ or fork this project and use it locally.

## How does it work?
To be able to access the file browser first you need to sign up for an
[Amazon S3](http://aws.amazon.com/s3/) account and use your valid access_key and
secret_key to sign in to Brows3. Don't worry, no information is kept in any
database.

Once logged in you will be able to see a list of all the S3 buckets in your
account. Click your favorite and start browsing its contents. You should find
the file navigation very familiar.

As usual, click on a folder to enter its contents and click on a file to begin
downloading it. The generated link is a
[read-only presigned URL](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/S3Object.html#url_for-instance_method).

You can check the [FAQ](https://github.com/tractical/brows3/blob/master/views/faq.erb)
view for some common questions.

## Project dependencies
* ruby 1.9.3p125
* sinatra 1.3.3
* aws-sdk 1.7.1
* sprockets 2.9.3

## Setup Development Environment
1. Install Ruby. You can use [rbenv](https://github.com/sstephenson/rbenv) or
any [other method](http://www.ruby-lang.org/en/downloads/) you prefer.

2. Clone the repository

        $ git clone git@github.com:tractical/brows3.git

3. Run bundle to install the required gems.

        $ bundle install

4. Run the application.

        $ rackup config.ru

## Deployment
Brows3 is ready for deploy to [Heroku](http://www.heroku.com/).

1. If you don't have a Heroku account follow their
[quickstart](https://devcenter.heroku.com/articles/quickstart)
guide to create it and get ready to
[deploy a Ruby application](https://devcenter.heroku.com/articles/ruby).

2. For a Rack app we need to
[declare a process type](https://devcenter.heroku.com/articles/ruby#declare-process-types-with-procfile)
with Procfile.

        # Procfile
        web: bundle exec rackup config.ru -p $PORT

3. For security reasons we're using a SSL endpoint. It is enabled by default in
the [ApplicationController](https://github.com/tractical/brows3/blob/master/controllers/application_controller.rb).
You can disable it by setting the `use_ssl` option to false.

  3.1. To setup a SSL endpoint in Heroku you can follow their
  [guide](https://devcenter.heroku.com/articles/ssl-endpoint).

4. Finally create a custom
[session secret](http://www.sinatrarb.com/intro#Using%20Sessions) to sign your
session data. You can use the same one defined in your `config.yml` local settings
file.

        $ heroku config:add SESSION_SECRET=yoursessionsecretkey

5. You are ready to go!
