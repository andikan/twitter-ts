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

#conncet to db:{twitter} , collection:{user}
db = connection.db("twitter")
user_collection = db.collection("user")

#check the number of user in db
total_count = user_collection.count
#index = total_count + 1

#the begining user
screen_name = String.new ARGV[0]

#check user in the db ? insert : or not insert
if user_collection.find(:screen_name => screen_name).to_a.count == 0
  begin
    first_user = Twitter.user(screen_name)

  rescue Twitter::Error => e
    puts e.to_s
    sleep(60)
    retry
  end

  #the first user
  data = first_user.attrs
  #data[:index] = index
  user_collection.insert(data)
  puts "Index : " + total_count.to_s + ", name : " + first_user.name + "   Insert to { db : twitter , collection : user }"
  #index += 1

else
  puts "User name : " + screen_name + " exist in the { db : twitter , collection : user }"
  puts "Do not insert."
end


cursor = -1
# find first_user's all followers
while cursor != 0 do
  # get the follower's in the page
  begin
  	followers = Twitter.follower_ids(screen_name, :cursor=>cursor)
    puts Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"
  rescue Twitter::Error => e
  	puts "[find follower_ids] " + e.to_s
  	sleep(5)
  	retry
  end
  
  # insert the follower's data in this page
  followers.ids.each do |fid|
    #check user in the db ? insert : or not insert
    if user_collection.find(:id => fid).to_a.count == 0
      begin
        f = Twitter.user(fid)
        data = f.attrs
        #data[:index] = index
   
        user_collection.insert(data)
        total_count = user_collection.count
        puts "Index : " + total_count.to_s + ", name : " + f.name + "   Insert to { db : twitter , collection : user }"
        #index += 1

      rescue Twitter::Error => e
        puts e.to_s
        if e.to_s == "Sorry, that page does not exist"
          puts "continue to the next......"
        elsif e.to_s == "getaddrinfo: Name or service not known"
          puts "continue to the next......"         
        elsif e.to_s == "Rate limit exceeded. Clients may not make more than 350 requests per hour."
          puts "take a break ......"
          sleep(5)
        else
          puts "continue to the next......" 
        end
      end

    else
      puts "User id : " + fid.to_s + " exist in the { db : twitter , collection : user }"
      puts "Do not insert."
    end
  end
  
  puts "process ensure_index ........."
  user_collection.ensure_index :id, :unique => true, :dropDups => true
  #user_collection.ensure_index [[:index, Mongo::ASCENDING]], :unique => true, :dropDups => true
  #check the number of user in db
  #total_count = user_collection.count
  #index = total_count + 1

  # to the next page
  puts "to the next page ->"
  cursor = followers.next_cursor
end

puts "====================================================================================================="
puts "END TO COLLECT " + first_user.name + " AND FOLLOWERS."
puts "TOTAL NUMBER : " + user_collection.count









