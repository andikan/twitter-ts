#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
require 'mongo'

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

us_user = user_collection.find('statuses_count' => {'$gt' => 10}).to_a
(0..10).each do |i|
	puts "no.#{i+1}  "
	puts us_user[i+1]['name'].to_s + "  " + us_user[i+1]['statuses_count'].to_s
end 
puts us_user.count.to_s


