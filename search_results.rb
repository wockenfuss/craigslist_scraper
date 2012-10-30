require 'nokogiri'
require 'open-uri'
require 'fakeweb'

class SearchResult
attr_reader :url, :search_date, :search_term, :posts
	#url, date, terms
	#methods
		#parse
		#save
	def initialize(url, search_term)
		@url = url
		@search_date = Time.now
		@search_term = search_term
		@urls = []
		@posts = []
	end

	def parse
		@doc = Nokogiri::HTML(open(@url))
		@urls = @doc.css("p [class = 'row']/a").collect {|link| link['href'] }

	end

	def list_of_posts
			@urls.each do |link|
			p @posts << Posting.new(link)
		end
	end
	
end

class Posting

	def initialize(url)
	end

end

# test = SearchResult.new('http://sfbay.craigslist.org/pen/apa/3372916109.html', 'bike')
# test.parse