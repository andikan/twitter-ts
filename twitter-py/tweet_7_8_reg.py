
import pymongo
import numpy as np
import matplotlib.pyplot as plt
import time
import datetime
from dateutil.parser import parse

connection = pymongo.Connection('localhost', 27017)
db = connection.twitter
store_tweet_collection = db['tweet_in_7_8']

start = datetime.datetime(2012, 8, 20)
end = datetime.datetime(2012, 8, 21)

tweet = store_tweet_collection.find({"created_at": {"$gte": start, "$lt": end}})
print tweet.count()
# print tweet[0]['created_at']
# print tweet[0]['created_at'].year
# print tweet[0]['created_at'].month
# print tweet[0]['created_at'].day
# print tweet[0]['created_at'].hour
# print tweet[0]['created_at'].minute
# print tweet[0]['created_at'].second
