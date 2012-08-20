#!/usr/bin/env ruby
require 'twitter'
require 'mongo'

start_time = Time.now

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
user_collection = db.collection("user_filter3")
tweet_collection = db.collection("tweet_uf3_8_20")
logfile = File.open("collect_tweet_#{start_time}.log",'w+') #output file

#check the number of user in db
total_count = user_collection.count
logfile.write("process start at #{start_time}\n")
puts "fetch all user data......"
all_user = user_collection.find.to_a
puts "fetch all user data......sucessfully"


error_user = []
all_user.each do |user|
  puts "Start to fetch #{user['name']} 's tweets..."
  begin
    puts Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"
    user_tweet = Twitter.user_timeline(user['id'], :count => 300, :page => 1).to_a  
  rescue => e
    puts "exception: #{e.to_s}"
    if e.to_s == "Not authorized" or e.to_s == "Name or service not known"
      error_user.push(user['id'])
      puts "continue to the next......"         
      next
    elsif e.to_s == "Rate limit exceeded. Clients may not make more than 350 requests per hour."
      puts "take a break ......"
      sleep(5)
    end
    retry
  end
  
  puts "user:#{user['screen_name']}  => tweet_count:#{user_tweet.count}"
  user_tweet.each do |t|
    tweet_collection.insert(t.attrs) 
    puts "Insert:#{t['text']}"
  end
end

logfile.write("Collect Process Duration: #{Time.now - start_time} seconds\n")
logfile.write("error user:#{error_user}\n")
logfile.close
