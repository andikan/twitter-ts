import pymongo
import numpy as np
import matplotlib.pyplot as plt
import time
import datetime
from dateutil.parser import parse

connection = pymongo.Connection('localhost', 27017)
db = connection.twitter
tweet_collection = db['tweet_822']
store_tweet_collection = db['tweet_in_7_8']

for i in range(0, 119):
    all_tweet = tweet_collection.find().skip(i*10000).limit(10000)
    offset = 0 
    for tweet in all_tweet:        
        create_time = parse(tweet['created_at'])
        print "index:"+str(i*10000+offset)+" => time:"+str(create_time)
        if (create_time.year == 2012 and (create_time.month == 7 or create_time.month == 8)):
            data = {"created_at": create_time,
                    "text": tweet['text']}
            store_tweet_collection.insert(data)
        offset += 1
