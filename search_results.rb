require 'nokogiri'
require 'open-uri'
require 'fakeweb'
require 'sqlite3'
# require 'cldatabase.rb'
require './posting.rb'

class SearchResult
attr_reader :url, :search_date, :search_term, :posts, :primary_key
	#url, date, terms
	#methods
		#parse
		#save
	def initialize(database, url)
		@url = url
		@search_date = Time.now
		@search_term = search_term
		@urls = parsed_urls
		@posts = []
		@database = database
		#puts '"'+@search_term+'"'
	end

	def parsed_urls
		@doc = Nokogiri::HTML(open(@url))
		@urls = @doc.css("p [class = 'row']/a").collect {|link| link['href'] }
	end

	def list_of_posts
		@urls.each do |link|
			 @posts << Posting.new(@database, link, @primary_key)
		end
		@posts.each {|post| post.save}
	end

	def search_term
		split_url = @url.split('&')
		split_url.each do |element| 
			if element.include?("query")
				element.gsub!(/(.*)(query=)(.*)/, "\\3")
				@search_term = element
			end
		end
		@search_term
	end

	def save
		#puts "no_quote" + "#{self.search_term}"
		#puts "double_quote" + '"#{self.search_term}"'


		#@primary_key = @database.add_row("search_results", { search_term: '"'+@search_term+'"', url: '"'+@url+'"', search_date: '"'+"#{@search_date}"+'"' })
		@primary_key = @database.add_row("search_results", { s_search_term: @search_term, s_url: @url, s_search_date: @search_date})
		#@database.add_row("search_results", { search_term: '"Bike"', url: '"http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk="', search_date: '"this is a date"' })
	end

end