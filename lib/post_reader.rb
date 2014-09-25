class PostReader
  attr_accessor :posts

  def initialize
    post_paths = Dir.glob("views/posts/*/*/*/*")
    @posts = post_paths.collect { |post_path| Post.new(post_path) }
    @posts.sort_by! { |post| post.timestamp }
    @posts.reverse!
  end

  def most_recent(n)
    @posts.slice(0, n)
  end

  def next(n, start)
    @posts.slice(start, n)
  end

end

class Post
  attr_accessor :name, :path, :date, :timestamp, :contents

  def initialize(post_path)
    @name = post_path.split('/').last
    @name.gsub!(".erb", "")

    @path = post_path.gsub("views/", "")
    @path.gsub!(".erb", "")

    @timestamp = File.open(post_path).ctime # how can I get time created, not time changed?
    @date = timestamp.strftime "%Y-%m-%d"

    file = File.new(post_path)
    @contents = file.read
    @timestamp = file.ctime
    @date = @timestamp.strftime "%Y/%m/%d"
  end
end
