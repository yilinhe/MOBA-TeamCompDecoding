from bs4 import BeautifulSoup
import urllib2
import ast
from ChampionDictionary import getChampionInfo
from DBConnector import createSqlString, getPlayerFromDB, executeQueries


def getPlayerIds():
    '''
    get the top ranked player ids from lolsummoners.com website.
    :return:
    '''
    for page_num in range(1):
        # Get Data
        page = urllib2.urlopen("http://www.lolsummoners.com/leagues/na/" + str(page_num + 1))
        soup = BeautifulSoup(page)
        k = soup
        players = []
        # get player id sorted by ranked score
        player_list = [i.findAll('a') for i in k.findAll('td', {"class": "name"})]
        for player in player_list:
            if len(player) > 0:
                url = player[0].get('href').split('/')
                if url[1] == 'players' and url[2] == 'na':
                    players.append(url[3])
    return players


def getPlayerInfo(player_id):
    '''
    Return a dictionary of player's performance score given a particular ranked champion.
    The data was obtained from lolking based on season 4 performance.
    :param player_id:
    :return: dictionary of player's familarity with a particular champion
    e.g. {104: 0.21328846223286, 201: 0.0, 42: 0.0}
    '''

    # Check if we already have the data for this player
    info = getPlayerFromDB(player_id)
    if info != None:
        result = list(info)
        result[2] = ast.literal_eval(result[2])
        return result

    # Get Data
    page_url = "http://www.lolking.net/summoner/na/" + str(player_id) + "#ranked-stats"
    page = urllib2.urlopen(page_url)
    soup = BeautifulSoup(page)
    k = soup
    name = k.find(id='summoner-titlebar-summoner-name').get_text().encode('utf-8')
    champions = k.find('table', {'class': 'clientsort season_4_ranked_stats'}).findAll('td')
    # get player's performance on each champion in ranked games during season 4.
    counter = 0
    familarity = {}
    for champion in champions:
        if counter == 0:
            champion_name = champion.get('data-sortval')
        champion_id = int(getChampionInfo(champion_name)['champion_id'])
        if counter == 4:
            familarity[champion_id] = float(champion.get('data-sortval'))
        counter = (counter + 1) % 9
    storePlayerInfo([player_id, name, familarity])
    return [player_id, name, familarity]


def storePlayerInfo(player_info):
    executeQueries([createSqlString("players", player_info)])


def getPlayerFamilarity(player_id, champion_id):
    familarity = getPlayerInfo(player_id)[2]
    if champion_id in familarity:
        return getPlayerInfo(player_id)[2][champion_id]
    else:
        return 0


def getPlayerMatchHistory(match_history):
    return [i['matchId'] for i in match_history['matches']]
