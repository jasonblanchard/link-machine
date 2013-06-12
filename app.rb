require 'sinatra'
require 'mongoid'

Mongoid.load!("config/mongoid.yml")

class Link
    include Mongoid::Document

    field :url, :type => String
end

get '/hi' do
    "hello, world"
end
