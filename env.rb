configure do
  db = URI.parse('postgres://root:@localhost/lossless_dj')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )

  Mail.defaults do
    delivery_method :smtp, {
      :address => 'smtp.gmail.com',
      :port => 587,
      :domain => 'localhost',
      :user_name => 'lossless.pocket.dj@gmail.com',
      :password => 'pocketdjpass',
      :authentication => 'plain',
      :enable_starttls_auto => true
    }
  end
end
