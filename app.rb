require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cookies'
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

  def authorization_mail
    Mail.deliver do
      to      'berozzy@gmail.com'
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
    sass :"styles/#{filename}", Compass.sass_engine_options
    .merge(style: :compressed)
  end

  get '/' do
    slim :index
  end

  get '/login' do
    slim :login
  end

  get '/invite' do
    slim :invite
  end
end
