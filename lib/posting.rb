# Posting.new(url)
# .parse



class Posting

  def initialize(url)
    @doc = Nokogiri::HTML(open(url))
    @url = url
    @title = title
    #   @location

  end

  def title
    @title = @doc.css('h2')[0].content
  end

  def location
  end

end