require 'restclient'
require 'multimap'
require './cldatabase.rb'

class Email
  def initialize(posting_objects_array)
    @body = ""
    posting_objects_array.each do |posting|
      @body << "#{posting[:title]}, #{posting[:price]}, #{posting[:location]}, #{posting[:category]}, #{posting[:url]}\n"
    end
  end

  # def format_body(posting_objects_array)
  #   posting_objects_array.each do |posting|
  #     @body << "#{posting.title}, #{posting.price}, #{posting.date}, #{posting.category}, #{posting.url}"
  #   end
  # end


  def send
    data = Multimap.new
    data[:from] = "CL Scraper <user@clscraper.mailgun.org>"  #This will be the from, make sure to have your provided email address in <>
    data[:to] = "<janetlaichang@gmail.com>"
    data[:subject] = "Search Results from the Ugliest Site on the World Wide Web"
    data[:text] = @body
    #data[:html] = "<html>HTML version of the body</html>"  #haven't tried this yet, but let me know if you do something cool with it
    #data[:attachment] = File.new(File.join("./test_text.txt"))

    RestClient.post "https://api:key-8z0goj592iarsnq4nkc0fnol--fwqcy0"\
    "@api.mailgun.net/v2/clscraper.mailgun.org/messages", data           
  end

end

# email = Email.new
# email.format_body([Posting.new])
# email.send