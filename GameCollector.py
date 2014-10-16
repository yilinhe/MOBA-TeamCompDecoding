__author__ = 'yilinhe'

import time
from riotwatcher import RiotWatcher
from storematch import *

f = open('configuration.txt')
api_key = f.read()
w = RiotWatcher(api_key)


def wait():
    while not w.can_make_request():
        time.sleep(1)


def collect_info():
    # check if we have API calls remaining
    print(w.can_make_request())

    start_id = 1521649160
    print start_id

    counter = 0
    while True:
        counter += 1
        wait()
        try:
            collect_match(start_id+counter)
        except:
            print "exception while getting: "+ str(start_id+counter)
            continue

def collect_match(match_id):
    print "getting: "+ str(match_id)
    match = w.get_match(match_id, include_timeline=True)
    print match
    store_match(match)   
     
collect_info()