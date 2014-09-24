require 'sinatra'

class MyApp < Sinatra::Base # has many built in methods

  get '/' do # home page
    erb :index
  end

  get '/about-me' do
    erb "about_me".to_sym
  end

  get "/posts/:post_name" do
    name = params[:post_name]
    erb :"/posts/#{name}"
  end
end
