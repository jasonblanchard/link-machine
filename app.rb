require 'sinatra'
require 'mongoid'
require 'sinatra/flash'

enable :sessions

Mongoid.load!("config/mongoid.yml")

class Link
    include Mongoid::Document
    include Mongoid::Timestamps

    field :url, :type => String

    validates_presence_of :url
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
    @links = Link.desc(:created_at).map(&:url)
    erb :history
end

post '/create' do

    Link.desc(:created_at).skip(20).each { |r| r.destroy } if Link.all.to_a.length > 20

    if params[:password] == 'pass'
        url = params[:link]
        link = Link.new(:url => url)
        session['password'] = params[:password]
    else
        flash[:warning] = 'nope'
        redirect to('/new')
        return
    end

    if link.save
        redirect to('/new')
        return
    else
        flash[:warning] = 'no link'
        redirect to('/new')
    end

end

get '/' do
    redirect to('/last')
end

get '/last' do
    link = Link.last.url
    redirect to(link)
end
