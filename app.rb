require 'sinatra'
require 'mongoid'

Mongoid.load!("config/mongoid.yml")

class Link
    include Mongoid::Document
    include Mongoid::Timestamps

    field :url, :type => String
end

get '/hi' do
    "hello, world"
end

get '/new' do
    @current_link = Link.last
    erb :new
end

get '/history' do
    @links = Link.desc(:created_at).limit(20).map(&:url)
    erb :history
end

post '/create' do
    link = params[:link]
    Link.create(:url => link)
    redirect to('/new')
end
