require './libs'
require './env'
require './db/classes'

class LosslessDJ < Sinatra::Base
  helpers Sinatra::Cookies

  def authorized? request
    authorized = cookies[:authorized]
    session = Sessions.where(secret_code: cookies[:secret], useragent: request.user_agent, session_ip: request.ip, expired: false, forced: false, exited: false)
    if authorized and !!cookies[:secret] and session.exists?
      session.last.touch
      true
    else
      false
    end
  end

  def authorize secret, request, uid
    cookies[:authorized] = true
    cookies[:user] = uid
    cookies[:secret] = secret
    {success: true, response: "You are authorzied!", reload: true}.to_json
  end

  def try_to_activate_user user, params, ip
    if params[:code].empty?
      authorization_mail params[:email], user[:id]
    else
      find_and_authorize_by user[:id], params[:code].upcase!
    end
  end

  def authorization_mail email, uid
    code = MemorablePassword.new.generate(length:10).upcase

    Secrets.where(users_id: uid).each do |secret|
      secret.forced = true
      secret.save
    end

    secret = Secrets.new
    secret.users_id = uid
    secret.secret_code = code
    secret.save

    send_code_on email, code
    {success: true, response: "Check your e-mail"}.to_json
  end

  def send_code_on email, code
    Mail.deliver do
      to      email
      from    'Lossossless.DJ'
      subject 'Lossossless: Login Access'
      body    "Your login code: #{code}."
    end
  end

  def confirm secret
    secret = secret.take!
    secret.confirmed = true
    secret.save!
  end

  def session_create session, uid, code, request
    secret = Digest::SHA1.hexdigest code + request.ip + request.user_agent
    session = Sessions.new
    session.user_id = uid
    session.session_ip = request.ip
    session.secret_code = secret
    session.useragent = request.user_agent
    session.secret_key = code
    session.save

    authorize secret, request, uid
  end

  def find_and_authorize_by uid, code
    secret = Secrets.where('users_id = :users_id AND secret_code = :secret_code AND expires > NOW() AND confirmed = false', {users_id: uid, secret_code: code})
    if secret.exists?
      confirm secret
      session_create session, uid, code, request
    else
      {success: false, response: "You made an error or your secret code has expired"}.to_json
    end

  end

  before %r{/(?!login|invite|(.[^\.]))} do |url|
    @request = request
    redirect to '/login' if not authorized? request
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
      try_to_activate_user user.take!, params, request.ip
    else
      {success: false, response: "Wrong credentials"}.to_json
    end
  end

  get '/invite' do
    slim :invite
  end
end
