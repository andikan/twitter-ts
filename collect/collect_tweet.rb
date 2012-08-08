#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
require 'mongo'

#set twitter oauth
Twitter.configure do |config|
  config.consumer_key = "qr7DUTlTG0yL35mtUHz7g"
  config.consumer_secret = "vAKUFH5AgaTexaybNPmewoWC0GAK9ftiWQdTp1DL0"
  config.oauth_token = "608427831-8CKLOkFAGL1neZHQxd7cyxBZgCofKmdNa9HYdg3R"
  config.oauth_token_secret = "Z7rDSWw5SyEsQ1KzHuuBWJmVF6X7eV5D1hCyKY2gU"
end

puts Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"

#connect to mongoDB
begin
  connection = Mongo::Connection.new("localhost", 27017)
  puts "Connect to mongoDB......"
rescue Mongo::MongoDBError => e
  puts e.to_s
  exit
end

#conncet to db:{twitter} , collection:{user} and {tweet}
db = connection.db("twitter")
user_collection = db.collection("user")
tweet_collection = db.collection("tweet")

#check the number of user in db
total_count = user_collection.count

puts "fetch all user data......"
all_user = user_collection.find.to_a
puts "fetch all user data......sucessfully"

all_user.each do |user|
	puts "user name = #{user['screen_name']}, user status count = #{user['statuses_count']}"
	if user['statuses_count'] == 0
		puts "the user #{user['screen_name']} have no tweet"
	else
		if user['statuses_count'] < 3200
			page_count = user['statuses_count']/200
			puts "start to fetch #{user['screen_name']} 's tweets..."
			(1..page_count+1).each do |page|
				begin
				    timeline = Twitter.user_timeline(screen_name, :count => 200, :page => page)	    	
				    puts Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"
         rescue Twitter::Error => e
				  	puts "[find follower_ids] " + e.to_s
				  	sleep(5)
				  	retry
				end
			end
		end
	end
	puts Twitter.user_timeline(en_user[u]['screen_name']).first.text
end
