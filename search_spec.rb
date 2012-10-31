require 'simplecov'
SimpleCov.start
require_relative './search_results.rb'
#require 'fakeweb'

class Posting
	attr_accessor :url
	def initialize(url)
		@url = url
	end
end


describe SearchResult do
	before(:each) do
		apartment_result = File.read("craigslist_test.html")
		FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk=", :body => apartment_result)
		@doc = Nokogiri::HTML(open('http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk='))
	end

	let (:result) {SearchResult.new("database","http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk=")}

	context "#initialize" do 
		it "returns a search result" do 
			result.should be_an_instance_of SearchResult
		end

		it "responds to url" do
			result.should respond_to(:url)
		end

		it "responds to search_date" do
			result.should respond_to(:search_date)
		end

		it "responds to search term" do
			result.should respond_to(:search_term)
		end

		it "returns a url" do 
			result.url.should == 'http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk='
		end

		it "search date is equal to timestamp" do 
			result.search_date.should be <= Time.now
		end

	end




	context "#parsed_urls" do
		before(:each) do 
			apartment_result = File.read("craigslist_test.html")
			FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk=", :body => apartment_result)
		end

		let (:result) {SearchResult.new("database","http://sfbay.craigslist.org/search/bia?query=bicycle&srchType=A&minAsk=&maxAsk=")}

		it "returns a collection of urls" do
			urls = result.parsed_urls
			urls.each do |url|
				url.should match(/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?/)
			end
		end
	end

	context "#list_of_postings" do 
		it "should give us an array of each element consisting of Posting instances" do 
			result.parsed_urls
			result.list_of_posts
			result.posts.each do |post|
				post.should be_an_instance_of Posting
			end
		end
	end

	context "#search_term" do 
		it "should give us the query string entered from the url" do 
			result.search_term.should eq "bicycle"
		end
	end

	context "#save" do
		it "takes a database method and gives it arguements to pass along" do
	end



end





























