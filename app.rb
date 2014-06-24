require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cookies'
require 'json'
require 'mail'
require 'slim'
require 'compass'

require './env'
require './schemes'

class LosslessDJ < Sinatra::Base
  helpers Sinatra::Cookies

  def authorized?
    cookies[:authorized]
  end

  def authorize
    cookies[:authorized] = true
  end

  def authorization_mail email
    Mail.deliver do
      to      email
      from    'lossless.pocket.dj@gmail.com'
      subject 'testing sendmail'
      body    'testing sendmail'
    end
  end

  before %r{/(?!login|invite|(.[^\.]))} do |url|
    redirect to '/login' if not authorized?
  end

  error do
    redirect '/error'
  end

  get '/*.css' do |filename|
    style = "#{settings.public_folder}/#{filename}.css"
    return File.read(style) if File.exists?(style)

    # TODO: Setup production sass compiling
    # Compass.compiler.compile("#{filename}.sass", "#{filename}.css") if ENV['RACK_ENV'] == "production"

    sass :"styles/#{filename}", Compass.sass_engine_options
    .merge(style: :compressed)
  end

  get '/' do
    slim :index
  end

  get '/login' do
    slim :login
  end

  post '/login' do
    error = "Wrong credentials"
    return error if !params[:email] or params[:email] == ""
    users = Users.where(actual_email: params[:email])
    return error if users.size == 0
    content_type :json
    authorization_mail params[:email]
    {success: true, response: "Check your e-mail"}.to_json
  end

  get '/invite' do
    slim :invite
  end
end
