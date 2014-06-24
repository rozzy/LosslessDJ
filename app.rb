class LosslessDJ < Sinatra::Base
  get '/' do
    slim :index
  end
end
