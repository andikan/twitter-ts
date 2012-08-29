'''
Created on Aug 20, 2012

@author: andy
'''
import pymongo
from datetime import datetime

connection = pymongo.Connection('localhost', 27017)
db = connection.twitter
tweet_connection = db.tweet_uf3_8_20

start = datetime(2012, 8, 1)
end = datetime(2012, 8, 31)

print start

july_tweet = []
july = tweet_connection.find({"id": {"$exits": "true"}})
for t in july:
    july_tweet.append(t)

print len(july_tweet)

