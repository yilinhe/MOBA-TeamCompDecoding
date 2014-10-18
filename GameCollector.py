__author__ = 'yilinhe'

import time
from riotwatcher import RiotWatcher
from MatchStore import *
from PlayerInfoCollector import *

f = open('configuration.txt')
api_key = f.read()
w = RiotWatcher(api_key)


def wait():
    while not w.can_make_request():
        time.sleep(1)

def collectInformation():
    # check if we have API calls remaining
    print(w.can_make_request())

    player_list = collectPlayerIds()

    for player in player_list:
        # get player match history
        matches = getPlayerMatchHistory()
        for match in matches:
            # check if game is already stored
            if getMatchFromDB(match):
                continue
            match_info = getMatch(match)
            team_100 = {}
            for player_id, champion_id in match_info['team_100'].items():
                team_100[champion_id] = getPlayerFamilarity(player_id,champion_id)
            team_200 = {}
            for player_id, champion_id in match_info['team_200'].items():
                team_200[champion_id] = getPlayerFamilarity(player_id,champion_id)
            match_info['team_100'] = team_100
            match_info['team_200'] = team_200
            print match_info
 
     
collect_info()