require 'sinatra'

class MyApp < Sinatra::Base # has many built in methods

  get '/' do # home page
    erb :index
  end

  get '/about-me' do
    "I am a bear"
  end

end
