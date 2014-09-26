class PostReader
  attr_accessor :posts, :count

  def initialize
    post_paths = Dir.glob("views/posts/*/*/*/*")
    @posts = post_paths.collect { |post_path| Post.new(post_path) }
    @posts.sort_by! { |post| post.timestamp }
    @posts.reverse!
    @count = @posts.count
  end

  def most_recent(n)
    @posts.slice(0, n)
  end

  def slice(start, n)
    @posts.slice(start, n)
  end

  def empty?
    @count == 0
  end

  def first_page?(splat)
    [nil, '', '1'].include? splat
  end

  def last_page?(page)
    page * 5 >= @count
  end

  def last_page
    (@count/5.0).ceil
  end

  def first_index_heading
    case @count
    when 0 then "I haven't made any posts!"
    when 1 then "My one lonely post:"
    when 2..5 then "All #{@count} posts:"
    else "Latest 5 posts:"
    end
  end

  def later_index_heading(page)
    page = page.to_i
    if last_page?(page)
      if page * 5 == @count
        "Oldest 5 posts:"
      else
        on_last_page = @count % 5
        on_last_page == 1 ? "Oldest post:" : "Oldest #{on_last_page} posts:"
      end
    else
      first = (page - 1) * 5 - 1
      last = page * 5
      "Posts \##{first} - \##{last}:"
    end
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
