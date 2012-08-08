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

#check the number of user in db
total_count = user_collection.count
index = 1

puts "fetch all user data......"
all_user = user_collection.find.to_a
puts "fetch all user data......sucessfully"

all_user.each do |u|
	user_collection.update({"id" => u['id']}, {"$set" => {'index' => index }})
	puts "set id : #{u['id']}, name :#{u['name']} => index : #{index}"
	index += 1
end


puts "all index  = #{index}, all user = #{total_count}"