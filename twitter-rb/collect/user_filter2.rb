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
user_collection = db.collection("user") #input
filter_collection = db.collection("user_filter2") #output

puts "fetch data from user_collection ......"
all_user = user_collection.find({"$and"=>[{"statuses_count"=>{"$gt"=>0}},
                                          {"status"=>{"$exists"=>true}},
                                          {"protected"=>false},
                                          {"statuses_count"=>{"$gt"=>200}},
                                          {"lang"=>"en"}] })
                                           
puts "fetch data from user_collection ...... successfully"

index = 1                                    
all_user.to_a.each do |u|
  # calculate day from account create to now
  now_time = Time.new(2012,8,8,0,0,0, "+08:00")
  create_time = Time.parse(u['created_at'])
  account_period = (now_time - create_time)/86400
  
  insert_data = {}
  insert_data['id'] = u['id']
  insert_data['name'] = u['name']
  insert_data['created_at'] = u['created_at']
  insert_data['followers_count'] = u['followers_count']
  insert_data['friends_count'] = u['friends_count']
  insert_data['account_period'] = account_period.round(0)
  insert_data['statuses_count'] = u['statuses_count']
  insert_data['avg_tweet'] = u['statuses_count']/(account_period.round(0))
  insert_data['latest_status'] = u['status']
  
  filter_collection.insert(insert_data)
  puts "#{index} ,   Insert #{insert_data['name']} into user_filter2."
  index += 1
end

puts "Total all_user : #{all_user.count}"