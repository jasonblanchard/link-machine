require 'sinatra'
require 'mongoid'
require 'sinatra/flash'

enable :sessions

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
    @password = session[:password]
    @current_link = Link.last.url if Link.last
    erb :new
end

get '/history' do
    @links = Link.desc(:created_at).limit(20).map(&:url)
    erb :history
end

post '/create' do
    if params[:password] == 'pass'
        link = params[:link]
        Link.create(:url => link)
        session['password'] = params[:password]
    else
        flash[:warning] = 'nope'
    end

    redirect to('/new')
end

get '/last' do
    link = Link.last.url
    redirect to(link)
end
