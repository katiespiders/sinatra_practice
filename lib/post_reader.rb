class PostReader
  attr_accessor :count, :last_page
  PER_PAGE = 5

  def initialize
    post_paths = Dir.glob("views/posts/*/*/*/*")
    @posts = post_paths.collect { |post_path| Post.new(post_path) }
    @posts.sort_by! { |post| post.timestamp }
    @posts.reverse!
    @count = @posts.count
    @last_page = (@count/PER_PAGE.to_f).ceil
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

  def first_page?(page)
    [0,1].include? page
  end

  def last_page?(page)
    page * PER_PAGE >= @count
  end

  def first_index_heading
    case @count
    when 0 then "I haven't made any posts yet!"
    when 1 then "My one lonely post:"
    when 2..PER_PAGE then "All #{@count} posts:"
    else "Latest #{PER_PAGE} posts:"
    end
  end

  def later_index_heading(page)
    if last_page?(page)
      if page * PER_PAGE == @count
        "Oldest #{PER_PAGE} posts:"
      else
        on_last_page = @count % PER_PAGE
        on_last_page == 1 ? "Oldest post:" : "Oldest #{on_last_page} posts:"
      end
    else
      first = (page - 1) * PER_PAGE + 1
      last = page * PER_PAGE
      "Posts \##{first} - #{last}:"
    end
  end

  def footer_links(page)
    if @last_page <= 5
      all_link_strings
    elsif near_start?(page)
      first_link_strings
    elsif near_end?(page)
      last_link_strings
    else
      mid_link_strings(page)
    end
  end

  def near_start?(page)
    page < 3
  end

  def near_end?(page)
    page + 2 > @last_page
  end

  # condense all this shit
  def all_link_strings
    links = ""
    (1..@last_page).each { |i| links += link_string(i) }
    links
  end

  def first_link_strings
    links = ""
    (1..5).each { |i| links += link_string(i) }
    links
  end

  def last_link_strings
    links = ""
    start = @last_page - 4
    (start..@last_page).each { |i| links += link_string(i) }
    links
  end

  def mid_link_strings(page)
    links = ""
    (page-2..page+2).each { |i| links += link_string(i) }
    links
  end

  def link_string(i)
    "<a href=\"/blog-index/#{i}\">#{i}</a> "
  end
end

class Post
  attr_accessor :name, :path, :date, :timestamp, :contents, :index_entry

  def initialize(post_path)
    @name = post_path.split('/').last
    @name.gsub!(".erb", "")

    @path = post_path.gsub("views/", "")
    @path.gsub!("blog-index", "")
    @path.gsub!(".erb", "")

    @timestamp = File.open(post_path).ctime # how can I get time created, not time changed? and this is even stupider with heroku because ctime is whenever i pushed to heroku
    @date = timestamp.strftime "%Y-%m-%d"

    file = File.new(post_path)
    @contents = file.read
    @timestamp = file.ctime
    @date = @timestamp.strftime "%Y/%m/%d"
  #  slice = @contents.slice(/A.{250}\S*/)

    snippet = @contents.slice(/<article>\s<p>\s.{200}\S*/)
    @index_entry = "<li><a href=\"/#{@path}\">#{@name}</a>   #{@date} </li><p>#{snippet} ...<p>"
  end
end
