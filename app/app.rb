require 'tilt/erb'
require 'sinatra/base'
require 'bcrypt'

require './app/dm_models_setup'

class Chitter < Sinatra::Base
  enable :sessions
  #session secret

  get '/' do
    redirect '/peeps'
  end

  get '/signup' do
    erb :signup_page
  end

  post '/signup' do
    #redir get signup if validation = false
    user = User.create(username: params[:username] , password: params[:password], email: params[:email])
    session[:user_id] = user.id
    redirect '/peeps'
  end

  post '/login' do
    declared_user = User.first(username: params[:username])
    raise "nil user" if declared_user.nil?
    session[:user_id] = declared_user.id if declared_user.password == params[:password]
    redirect '/peeps' #+warn if validation = false
  end

  get '/peeps' do
    current_user = User.first(id: session[:user_id])
    @peep_list = Peep.all
    @signed_in = !current_user.nil?
    if @signed_in
      @user = current_user.username
      @mail = current_user.email
    end
    erb :main_page
  end

  post '/add_peep' do
    text = params[:peep_text] #+warn if size > 200
    new_peep = Peep.create(content: text, date: DateTime.now)
    redirect '/peeps'
  end



end
