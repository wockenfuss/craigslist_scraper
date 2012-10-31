require 'nokogiri'
require 'open-uri'
require 'fakeweb'
require 'sqlite3'

class SearchResult
attr_reader :url, :search_date, :search_term, :posts
	#url, date, terms
	#methods
		#parse
		#save
	def initialize(database, url)
		@url = url
		@search_date = Time.now
		@search_term = search_term
		@urls = parsed_urls
		@posts = list_of_posts
		@database = database
	end

	def parsed_urls
		@doc = Nokogiri::HTML(open(@url))
		@urls = @doc.css("p [class = 'row']/a").collect {|link| link['href'] }
	end

	def list_of_posts
		@urls.each do |link|
			@posts << Posting.new(link)
		end
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
		@database.add_row('search_results', {'search_term' => '"#{search_term}"', 'url' =>'"#{url}"', 'search_date' => '"#{@search_date}"'})
	end

end