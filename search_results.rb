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
	def initialize(url)
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

end

# class DataBase
# 		def create_db
# 		 db = SQLite3::Database.new "dummy.db"
# 		 db.execute <<-SQL
# 				CREATE TABLE `search_results` (
# 				  `id` INTEGER NOT NULL,
# 				  `query` VARCHAR NOT NULL,
# 				  `created_on` TIMESTAMP NOT NULL,
# 				  PRIMARY KEY (`id`)
# 				);
# 			SQL
# 	end

# 	def populate_data


# 	end
# end

class Posting

	def initialize(url)

	end

end

# test = SearchResult.new('http://sfbay.craigslist.org/pen/apa/3372916109.html', 'bike')
# test.parse