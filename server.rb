require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require 'tilt/erb'

env = ENV['RACK_ENV'] || 'development'
DataMapper.setup(:default, "postgres://localhost/chitter_chatter_#{env}")
require './lib/user'
require './lib/peep'
DataMapper.finalize
DataMapper.auto_migrate!

class ChitterChatter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  use Rack::MethodOverride
  use Rack::Flash, sweep: true

  get '/' do
    @peeps = Peep.all
    erb :homepage
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    @username = params[:username]
    @password = params[:password]
    @user = User.new(username: params[:username],
                     name: params[:name],
                     email: params[:email],
                     password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      erb :homepage
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  post '/peeps/new' do
    Peep.create(message: params[:message])
    flash[:notice] = 'Peep has been posted!'
    redirect('/')
  end

  post '/sessions' do
    @user = User.authenticate(params[:username], params[:password])
    session[:user_id] = @user.id if @user
    erb :homepage
  end

  delete '/sessions/end' do
    session[:user_id] = nil
    redirect to('/')
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == ChitterChatter

end
