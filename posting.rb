class Posting

  def initialize(database, url)
    @doc = Nokogiri::HTML(open(url))
    @url = url
    @title = title
    @location = location
    @date = date
    @price = price
    @database = database
    @category = category
  end

  def title
    @title = @doc.css('title')[0].content
  end

  def location
    from_webpage = @doc.xpath('//div[@class="bchead"]/a')[1].content
    @location = from_webpage.split[0..-2].join(" ")
  end

  def date
    from_webpage = @doc.xpath('//span[@class="postingdate"]')[0].content
    @date = from_webpage.split[1..-1].join(" ")
  end

  def price
    @price = @doc.css('h2')[0].content.gsub(/(.*)(\$)(\d+)(.*)/,'\3')
  end

  def category
    @category = @doc.xpath('//div[@class="bchead"]/a')[-1].content
  end

  # def add_db(database)
  #   @database = database
  # end

  def save
    @database.add_row('postings', {'title' => '"#{@title}"', 'url' => '"#{@url}"'. 'price' => '"#{@price}"', 'date' => '"#{@date}"', 'location' => '"#{location}"'})
  end
end