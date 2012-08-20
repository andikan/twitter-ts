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
user_collection = db.collection("user_filter2") #input
filter_collection = db.collection("user_filter3") #output

puts "fetch data from user_collection ......"
all_user = user_collection.find()
                                           
puts "fetch data from user_collection ...... successfully"

unsort = []
index = 1                                    
all_user.to_a.each do |u|
  # calculate day from account create to now
  now_time = Time.now
  last_tweet_time = Time.parse(u['latest_status']['created_at'])
  period = (now_time - last_tweet_time)
  
  tuple = {}
  tuple = Hash['id'=>u['id'], 'time'=>period ]
  unsort.push(tuple)  
end
sorted = unsort.sort_by { |k| k['time'] }
(0..7999).each do |i|
  puts "id:#{sorted[i]['id']}  => time:#{sorted[i]['time']}"
  user = user_collection.find({"id"=>sorted[i]['id']}).to_a
  filter_collection.insert(user[0]) 
end

  
  
#  insert_data = {}
#  insert_data['id'] = u['id']
#  insert_data['name'] = u['name']
#  insert_data['created_at'] = u['created_at']
#  insert_data['followers_count'] = u['followers_count']
#  insert_data['friends_count'] = u['friends_count']
#  insert_data['account_period'] = account_period.round(0)
#  insert_data['statuses_count'] = u['statuses_count']
#  insert_data['avg_tweet'] = u['statuses_count']/(account_period.round(0))
#  insert_data['latest_status'] = u['status']
#  
#  filter_collection.insert(insert_data)
#  puts "#{index} ,   Insert #{insert_data['name']} into user_filter2."
#  index += 1
#end

#puts "Total all_user : #{all_user.count}"