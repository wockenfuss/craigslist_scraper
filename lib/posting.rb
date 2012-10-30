
class Posting

  def initialize(url)
    @doc = Nokogiri::HTML(open(url))
    @url = url
    @title = title
    @location = location
    @date = date
    @price = price
    @category = category
    #@loaded_info = load
  end

  def title
    #@title = @doc.css('h2')[0].content
    @title = @doc.css('title')[0].content
  end

  def location
    from_webpage = @doc.xpath('//div[@class="bchead"]/a')[1].content
    @location = from_webpage.split[0..-2].join(" ")
  end

  def category
    @category = @doc.xpath('//div[@class="bchead"]/a')[-1].content
  end

  def date
    from_webpage = @doc.xpath('//span[@class="postingdate"]')[0].content
    @date = from_webpage.split[1..-1].join(" ")
  end

  def price
    @price = @doc.css('h2')[0].content.gsub(/(.*)(\$)(\d+)(.*)/,'\3')
  end

  def save(database)
    insert_info = <<-eos
    INSERT INTO postings(title, url, price, location, category)
    VALUES("#{@title}", "#{@url}", #{@price.to_i}, "#{@location}", "#{@category}");
    eos
    database.execute(insert_info)
  end

  def load(database)
    database.execute("SELECT * FROM postings")
  end
end
