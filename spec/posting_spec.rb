require 'fakeweb'
require 'nokogiri'
require 'open-uri'
require "rspec"
require "./lib/posting.rb"




describe Posting do
  before :each do
    apartment_result = File.read("spec/fixtures/craigslist_sample_listing.html")
    FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/pen/apa/3372916109.html", :body => apartment_result)
    @doc = Nokogiri::HTML(open('http://sfbay.craigslist.org/pen/apa/3372916109.html'))
    # posting = Posting.new("http://example.com/test1")
    #    before(:each) do
    #        Interface.any_instance.stub(:gets).and_return("john", "johnspassword")
    #        create_interface(sf_gen)
    #      end
    #
  end

  context ".initialize" do
  #Posting.new
  #Posting.any_instance("http://sfbay.craigslist.org/pen/apa/3372916109.html")
    before :each do
      @posting = Posting.new("http://sfbay.craigslist.org/pen/apa/3372916109.html")
    end
    it "initializes with title of posting" do
      @posting.title.should include("THANKSGIVING IN TAHOE -- Wonderful house/location, hot tub, sleeps 10+")
    end


    # it "initializes the date posted" do
    #      @posting.date_posted.should eq("2012-10-29, 11:19AM PDT")
    #    end
    #
    it "initializes the location" do
      @posting.location.should eq("SF bay area")
    end
    #
    #    it "initializes the price" do
    #      @posting.price.should eq("SF bay area")
    #    end
  end


  #  context "#save" do
  #    it "saves the posting and its attributes to the database"
  #  end
  #
  #  context "#load" do
  #    it "loads the posting from the database"
  #  end

end

