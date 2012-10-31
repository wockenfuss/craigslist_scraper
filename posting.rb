require './cldatabase.rb'
require './search_results.rb'
require 'pry'

class Posting

  def initialize(database, url, foreign_key)
    @doc = Nokogiri::HTML(open(url))
    @url = url
    @title = title
    @location = location
    @date = date
    @price = price
    @database = database
    @category = category
    @foreign_key = foreign_key
  end

  def title
    @title = @doc.css('title')[0].content
    #puts @title
  end

  def location
    from_webpage = @doc.xpath('//div[@class="bchead"]/a')[1].content
    @location = from_webpage.split[0..-2].join(" ")
    #puts @location
  end

  def date
    date = @doc.xpath('//span[@class="postingdate"]')[0]
    if date == nil
      @date = "NO_DATE_RECORDED"
    else
      from_webpage = date.content
      @date = from_webpage.split[1..-1].join(" ")
    end
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
    #binding.pry
    # puts a = {title: '"#{@title}"', url: '"#{@url}"', price: '"#{@price}"', location: '"#{location}"', category: '"#{category}"'}
    # puts {'title' => '"#{@title}"', 'url' => '"#{@url}"', 'price' => '"#{@price}"', 'location' => '"#{location}"', 'category' => '"#{category}"'}
    if !@title.empty? && !@url.empty? && !@price.empty? && !@location.empty? && !@category.empty?
      @database.add_row('postings', { s_title: @title, s_url: @url, i_price: @price, s_location: @location, s_category: @category, i_track_search_result: @foreign_key })
    end
  end
end