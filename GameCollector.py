__author__ = 'yilinhe'

import time
from riotwatcher import RiotWatcher
from MatchStore import storeMatchInfo, getMatch
from PlayerInfoCollector import getPlayerIds,getPlayerMatchHistory,getPlayerFamilarity
from DBConnector import getMatchFromDB

f = open('configuration.txt')
api_key = f.read()
w = RiotWatcher(api_key)


def wait():
    while not w.can_make_request():
        time.sleep(1)


def collectInformation():
    # check if we have API calls remaining
    print(w.can_make_request())

    player_list = getPlayerIds()

    for player in player_list[:2]:
        # get player match history
        matches = getPlayerMatchHistory(w.get_match_history(player, ranked_queues=['RANKED_SOLO_5x5']))
        for match in matches:
            wait()
            print "getting match", str(match)
            # check if game is already stored
            if getMatchFromDB(match):
                continue
            match_info = getMatch(w.get_match(match, include_timeline=False))
            team_100 = {}
            for player_id, champion_id in match_info['team_100'].items():
                team_100[champion_id] = getPlayerFamilarity(player_id, champion_id)
            team_200 = {}
            for player_id, champion_id in match_info['team_200'].items():
                team_200[champion_id] = getPlayerFamilarity(player_id, champion_id)
            match_info['team_100'] = team_100
            match_info['team_200'] = team_200
            storeMatchInfo(match_info)
            print match_info
        print "finished collect player", player


collectInformation()