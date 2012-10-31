#!/usr/bin/env ruby
require './search_results.rb'
require "./posting.rb"
require "./email.rb"
require './cldatabase.rb'

class CraigslistUI
  def initialize(url, email)
    cld = CLDatabase.new("craigslist.db")
    cld.create_tables
    @search_result = SearchResult.new(cld, url)
    @search_result.save
    @search_result.list_of_posts
    postings = cld.read_rows(url)
    Email.new(postings).send(email)
    puts "Your email has now been sent!"
  end
end

url = ARGV[0]
email = ARGV[1]
CraigslistUI.new(url, email)


# http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=bicycle&catAbb=sss")
