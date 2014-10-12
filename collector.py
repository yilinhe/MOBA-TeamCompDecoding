__author__ = 'yilinhe'

import time
from riotwatcher import RiotWatcher,LoLException
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
            print "getting: "+ str(start_id+counter)
            match = w.get_match(start_id+counter, include_timeline=True)
            print match
            store_match(match)
        except:
            print "exception while getting: "+ str(start_id+counter)
            continue

collect_info()