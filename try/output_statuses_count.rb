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
db = connection.db("twitter")
filter_collection = db.collection("user_filter")
puts "fetch data from user_collection ......"
all_user = filter_collection.find()
puts "fetch data from user_collection ...... successfully"

output_file = File.open('try/statuses_count.data','w+')

all_user.each do |u|
  puts u['statuses_count']
  output_file.write("#{u['statuses_count']}\n") 
end

output_file.close