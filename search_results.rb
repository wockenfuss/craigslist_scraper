require 'nokogiri'
require 'open-uri'
require 'fakeweb'

class SearchResult
attr_reader :url, :search_date, :search_term
	#url, date, terms
	#methods
		#parse
		#save
	def initialize(url, search_term)
		@url = url
		@search_date = Time.now
		@search_term = search_term
		apartment_result = File.read("craigslist_test.html")
		FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/pen/apa/3372916109.html", :body => apartment_result)
		@doc = Nokogiri::HTML(open('http://sfbay.craigslist.org/pen/apa/3372916109.html'))

	end

	def parse
		#puts @doc.inspect
		@doc.css("p [class = 'row']/a").each do |link|
			puts link['href']

		#@doc.xpath('//p[class="row"]').each do |link|
			
			#puts link[:href]
		end
		# url_array = []
		# doc = Nokogiri::HTML(open(@url))
		# doc.css("p [class = 'row']").each do |link|
		# 	p link.content
		# end
	end



			
		# 	puts link
		# 	url_array << link
		# end
		# url_array
	

end

test = SearchResult.new('http://sfbay.craigslist.org/pen/apa/3372916109.html', 'bike')
test.parse