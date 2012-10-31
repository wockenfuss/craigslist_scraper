#take in user's queries
#calls search_result class, which calls postings class
#have a database with search results and postings
#load from database and make txt file for email with all information

include "search_results.rb"
include "posting.rb"
include "email.rb"

def CraigslistUI
	query_url = ARGV[0]
	cld = CLDatabase.new("craigslist.db")
	puts "What is the email you want these results sent to?"
	@user_email = gets.chomp
	@search_result = SearchResult.new(cld, query_url)
	@search_result.parse
	@search_result.list_of_posts
	

	Email.send_email(@user_email)
	puts "Your email has now been sent!"
end

user => CraigslistUI http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=bicycle&catAbb=sss
"What is your email?"
user => "blah@blah.com"

# require 'restclient'
# require 'multimap'
# # two required gems
# # gem install rest-client
# # gem install multimap

# # we used mailgun as our mailing service - they have good & extensive documentation
#class Email

# def self.send_email(user_email)
#   data = Multimap.new
#   data[:from] = "Ferdi <user@rocketsurgery.mailgun.org>"  #This will be the from, make sure to have your provided email address in <>
#   data[:to] = "someone@devbootcamp.com"
#   # data[:cc] = "serobnic@mail.ru"
#   # data[:bcc] = "sergeyo@profista.com"
#   data[:subject] = "Hey there! Message from Rocket Surgery for you!"
#   data[:text] = "If you received this mail scream 'TIMMEY!'"
#   data[:html] = "<html>HTML version of the body</html>"  #haven't tried this yet, but let me know if you do something cool with it
#   data[:attachment] = File.new(File.join("./test_text.txt"))
# #NB! add your accounts api key here, is provided by 
#   RestClient.post "https://api:key-8hzknxy69t8pwfpch6ltfmc398k0auh7"\       
# # replace 'samples.mailgun.org' in here "@api.mailgun.net/v2/samples.mailgun.org/messages" to your personal one
#   "@api.mailgun.net/v2/rocketsurgery.mailgun.org/messages", data           

# end

# send_email
