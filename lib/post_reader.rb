require 'date'

class PostReader
  attr_accessor :count, :last_page
  PER_PAGE = 2

  def initialize(posts_dir="views/posts/*/*/*/*")
    post_paths = Dir.glob(posts_dir)
    @posts = post_paths.collect { |post_path| Post.new(post_path) }
    @posts.sort_by! { |post| post.date }
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
      case @count % PER_PAGE
      when 0
        "Oldest #{PER_PAGE} Posts:"
      when 1
        "Oldest Post:"
      else
        "Oldest #{@count % PER_PAGE} Posts:"
      end
    else
      first = (page - 1) * PER_PAGE + 1
      last = page * PER_PAGE
      "Posts #{first} to #{last}:"
    end
  end

  def footer_links(page)
    if @last_page == 1
      nil
    elsif @last_page <= 5
      wrap(all_link_strings, page) + link_all
    elsif near_start?(page)
      wrap(first_link_strings, page) + link_last + link_all
    elsif near_end?(page)
      link_first + wrap(last_link_strings(page), page) + link_all
    else
      link_first + wrap(mid_link_strings(page), page) + link_last + link_all
    end
  end

  def footer_all
    if @last_page == 1
      nil
    elsif @last_page <=5
      all_link_strings + link_all
    else
      link_first + first_link_strings + link_last + link_all
    end
  end

  def near_start?(page)
    page.to_i < 3
  end

  def near_end?(page)
    page.to_i + 3 > @last_page
  end

  def all_link_strings
    links = ""
    (1..@last_page).each { |i| links += link_string(i) } if @last_page > 1
    links
  end

  def first_link_strings
    links = ""
    (1..5).each { |i| links += link_string(i) }
    links
  end

  def last_link_strings(page)
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

  def wrap(mid_string, page)
    (page>1 ? prev_string(page):"") + mid_string + (page<@last_page? next_string(page):"")
  end

  def link_string(page)
    "<a href=\"/blog-index/#{page}\">#{page}</a> "
  end

  def prev_string(page)
    "<a href=\"/blog-index/#{page-1}\">Prev</a> "
  end

  def next_string(page)
    page = 1 if first_page?(page)
    "<a href=\"/blog-index/#{page+1}\">Next</a> "
  end

  def link_first
    "<a href=\"/blog-index\">First Page</a>"
  end

  def link_last
    "<a href=\"/blog-index/#{@last_page}\">Last Page</a>"
  end

  def link_all
    "<a href=\"/blog-index/all\">All posts</a>"
  end
end

class Post
  attr_accessor :link, :name, :path

  def initialize(post_path)
    @post_path = post_path
    @link = "<a href=\"/#{file_path}\">#{file_name}</a>"
  end

  def file_name
    @post_path.split('/').last.gsub(".erb", "")
  end

  def file_path
    @post_path.gsub("views/", "").gsub("blog-index", "").gsub(".erb", "")
  end

  def contents
    file = File.new(@post_path)
    file.readlines
  end

  def post_contents
    contents.join
  end

  def snippet
    snippet = contents.join.slice(/<p>\s*.{200}\S*/)
    snippet ? snippet.gsub("<p>","") : snippet
  end

  def date
    path = @post_path.gsub("views/posts/", "")
    year = path.slice(0,4).to_i
    month = path.slice(5,2).to_i
    day = path.slice(8,2).to_i
    DateTime.new(year, month, day)
  end

end
