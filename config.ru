require 'sinatra/base'
Dir.glob('./{helpers,controllers}/*.rb').each { |file| require file }

map('/') { run ApplicationController }
map('/authenticate') { run AuthenticationController }