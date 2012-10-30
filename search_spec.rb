require 'simplecov'
SimpleCov.start
require_relative 'search_results'
require 'rspec'
require './search_data.rb'
require 'nokogiri'
require 'open-uri'

class Posting
	attr_accessor :url
	def initialize(url)
		@url = url
	end
end


describe SearchResult do
	let (:result) {SearchResult.new}

	context "#initialize" do 
		it "returns a search result" do 
			result.should be_an_instance_of SearchResult
		end

		it "contains the search result url"

		it "contains the search date"

		it "contains the search term"

	end

	

end

