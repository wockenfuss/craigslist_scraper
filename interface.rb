#take in user's queries
#calls search_result class, which calls postings class
#have a database with search results and postings
#load from database and make txt file for email with all information

require './search_results.rb'
require "./posting.rb"
require "./email.rb"
require './cldatabase.rb'


		#doc = Nokogiri::HTML(open('http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk='))

class Craigslistui
	def initialize(url)
		apartment_result = File.read("craigslist_test.html")
		FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk=", :body => apartment_result)
		@query_url = url
		# @query_url = ARGV[0]
		cld = CLDatabase.new("craigslist.db")
		cld.create_tables
		# puts "What is the email you want these results sent to?"
		# @user_email = gets.chomp
		@search_result = SearchResult.new(cld, @query_url)
		@search_result.save
		@search_result.list_of_posts
		postings = cld.read_rows(@query_url)
		Email.new(postings).send
		puts "Your email has now been sent!"
	end
end

Craigslistui.new("http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk=")
# http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=bicycle&catAbb=sss")

# user => CraigslistUI http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=bicycle&catAbb=sss
# "What is your email?"
# user => "blah@blah.com"
