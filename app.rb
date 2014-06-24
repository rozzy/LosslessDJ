require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cookies'
require 'json'
require 'mail'
require 'slim'
require 'memorable_password'
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

  def authorization_mail email, uid
    code = MemorablePassword.new.generate(length:10).upcase
    new_secret = Secrets.create(users_id: uid.to_i, secret_code: code)

    Mail.deliver do
      to      email
      from    'lossless.pocket.dj@gmail.com'
      subject 'Lossossless: Login Access'
      body    "Your login code: #{code}."
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
    content_type :json
    user = Users.where(actual_email: params[:email])
    if user.exists?
      authorization_mail params[:email], user.take![:id]
      {success: true, response: "Check your e-mail"}.to_json
    else
      {success: false, response: "Wrong credentials"}.to_json
    end
  end

  get '/invite' do
    slim :invite
  end
end
