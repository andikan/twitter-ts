'''
Created on Aug 14, 2012

@author: andy
'''
import pymongo
import numpy as np
import matplotlib.pyplot as plt
import time
import datetime
from dateutil.parser import parse


connection = pymongo.Connection('localhost', 27017)
db = connection.twitter
tweet_collection = db.tweet_822-23

all_tweet = tweet_collection.find().limit(10)

for tweet in all_tweet:
    create_time = parse(tweet['created_at'])
    print create_time
    
       

#hist_bin = []
#for i in range(51):
#hist_bin.append(i)    

#for u in all_user:
#    friend.append(u['friends_count'])
#    follower.append(u['followers_count'])
#    #friend_follower.append(data)
#plt.plot(friend, follower, 'ro')
#plt.axis([0, 2000, 0, 2000])
#plt.ylabel('followers')
#plt.xlabel('friends')
#plt.show()
    
#plt.hist([1, 2, 1], bins=[0, 1, 2, 3])
#plt.show()
