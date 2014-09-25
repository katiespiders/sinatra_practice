class PostReader
  attr_accessor :posts

  def initialize
    post_paths = Dir.glob("views/posts/*")
    @posts = []

    post_paths.each do |post_path|
      @posts << Post.new(post_path)
    end
  end
end

class Post
  attr_accessor :name, :path

  def initialize(post_path)
    @name = post_path.gsub("views/posts/", "")
    @name.gsub!(".erb", "")
    @path = post_path.gsub("views/", "")
    @path.gsub!(".erb", "")
  end
end
