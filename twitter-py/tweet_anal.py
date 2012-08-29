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
tweet_collection = db['tweet_822']
date_tweet_collection = db['date_tweet_count']
time_tweet = dict()

for i in range(0, 119):
    all_tweet = tweet_collection.find().skip(i*10000).limit(10000)
    offset = 0
    for tweet in all_tweet:
        print "index:"+str(i*10000+offset)+" => id:"+str(tweet['id'])
        create_time = parse(tweet['created_at'])
        if str(create_time.date()) in time_tweet:
            time_tweet[str(create_time.date())] += 1
        else:
            time_tweet[str(create_time.date())] = 1
        offset += 1

start_time = sorted(time_tweet.iterkeys())  #sort time_tweet key
print "collect tweet start at : " + str(start_time[0])
print "collect tweet end at : " + str(start_time[-1])

end_date = str((parse(start_time[-1])+datetime.timedelta(days=1)).date())

current_date = start_time[0]
while current_date != end_date:
    time = parse(current_date)
    if str(time.date()) not in time_tweet:
        time_tweet[str(time.date())] = 0
    print "time : %s  =>  value : %d" %(str(time.date()), time_tweet[str(time.date())])
    data = {"date":  str(time.date()),
            "count": time_tweet[str(time.date())] }
    date_tweet_collection.insert(data)
    
    current_date = str((time + datetime.timedelta(days=1)).date())







#for k in sorted(time_tweet.iterkeys()):
#    print "time: %s value: %d" %(k,time_tweet[k])

    

       

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
