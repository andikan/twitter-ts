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
hist_bin = []
for i in range(51):
    hist_bin.append(i*10)   

for u in all_user:
    friend.append(u['friends_count'])
    #friend_follower.append(data)
plt.hist(friend, bins= hist_bin)
plt.show()
