require 'sinatra'

class MyApp < Sinatra::Base # has many built in methods

  get '/' do # home page
    erb :index
  end

  get '/about-me' do
    erb "about_me".to_sym
  end

  get '/so-ugly' do
    erb "so_ugly".to_sym
  end

  get '/blog-index*' do
    erb "blog_index".to_sym
  end

  post '/blog-index' do
    redirect to("/blog-index")
  end

  get '/blog-all' do
    erb "blog_all".to_sym
  end

  get '/new-post' do
    erb "new_post".to_sym
  end

  get "/posts/:year/:month/:day/:post_name" do
    year, month, day, name = params[:year], params[:month], params[:day], params[:post_name]
    full_path = "/posts/#{year}/#{month}/#{day}/#{name}"
    erb full_path.to_sym
  end
end
