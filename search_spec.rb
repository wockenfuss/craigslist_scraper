require 'simplecov'
SimpleCov.start
require_relative 'search_results'
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
		FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/pen/apa/3372916109.html", :body => apartment_result)
		@doc = Nokogiri::HTML(open('http://sfbay.craigslist.org/pen/apa/3372916109.html'))
	end

	let (:result) {SearchResult.new('www.google.com', 'bike')}

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
			result.url.should == 'www.google.com'
		end

		it "search date is equal to timestamp" do 
			result.search_date.should be <= Time.now
		end

		it "returns the search term" do
			result.search_term.should eq "bike"
		end

	end




	context "#parse" do
		let (:result) {SearchResult.new("http://sfbay.craigslist.org/pen/apa/3372916109.html", 'bike')}
		#mock = result.stub!(:parse).and_return
		it "returns a collection of urls" do
			p urls = result.parse
			urls.each do |url|
				#puts url.inspect
				#url.should_not match(/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?/)
			end
		end
	end

	

end

