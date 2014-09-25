class PostReader
  attr_accessor :posts

  def initialize
    post_paths = Dir.glob("views/posts/*/*/*/*")
    @posts = post_paths.collect { |post_path| Post.new(post_path) }
    @posts.sort_by { |post| post.timestamp }.reverse!
  end

  def most_recent(n)
    @posts.slice(0, n)
  end
end

class Post
  attr_accessor :name, :path, :date, :timestamp

  def initialize(post_path)
    @name = post_path.split('/').last
    @name.gsub!(".erb", "")

    @path = post_path.gsub("views/", "")
    @path.gsub!(".erb", "")

    @timestamp = File.open(post_path).ctime
    @date = timestamp.strftime "%Y-%m-%d"
  end
end
