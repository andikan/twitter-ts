'''
Created on Aug 14, 2012

@author: andy
'''
import pymongo
import numpy as np
import matplotlib.pyplot as plt


connection = pymongo.Connection('localhost', 27017)
db = connection.twitter
filter_connection = db.user_filter

all_user = filter_connection.find()
friend = []
follower = []
#hist_bin = []
#for i in range(51):
#hist_bin.append(i)    

for u in all_user:
    friend.append(u['friends_count'])
    follower.append(u['followers_count'])
    #friend_follower.append(data)
plt.plot(friend, follower, 'ro')
plt.axis([0, 2000, 0, 2000])
plt.ylabel('followers')
plt.xlabel('friends')
plt.show()
    

#plt.hist([1, 2, 1], bins=[0, 1, 2, 3])
#plt.show()
