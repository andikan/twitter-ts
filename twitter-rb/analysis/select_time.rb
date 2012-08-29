#!usr/bin/env ruby
require 'mongo'

#connect to mongoDB
begin
  connection = Mongo::Connection.new("localhost", 27017)
  puts "Connect to mongoDB......"
rescue Mongo::MongoDBError => e
  puts e.to_s
  exit
end

#conncet to db:{twitter} , collection:{user}, {user_filter}
db = connection.db("twitter")
user_collection = db.collection("user")
tweet_collection = db.collection("tweet_uf3_8_20")

start_time = Time.local(2012,7,1,0,0,0)
end_time =  Time.local(2012,8,1,0,0,0)

puts "fetch data from user_collection ......"
tweet = tweet_collection.find().first
  
puts "fetch data from user_collection ...... successfully"
puts tweet['created_at'].inspect