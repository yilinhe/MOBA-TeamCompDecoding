__author__ = 'yilinhe'
from DBConnector import createSqlString, executeQueries

def getMatch(match):
    '''
    return a dictionary of match result:
    {matchId:match_id, winner:team100, team_100:{p1:champ1 ... p5:champ5}, team_200:{p1:champ1 ... p5:champ5} }
    '''

    # Store the participants info relates to this match
    participants = match['participants']

    # the a participantId to summonerId mapping
    id_dict = getParticipantsId(match['participantIdentities'])
    winner = getWinnerTeam(match['teams'])

    team_100 = {}
    team_200 = {}

    # store the participantion
    for p in participants:
        player_id = id_dict[p['participantId']]
        if p['teamId'] == 100:
            team_100[player_id] = p['championId']
        else:
            team_200[player_id] = p['championId']

    result = {}
    result['matchId'] = match['matchId']
    result['winner'] = winner
    result['duration'] = match['matchDuration']
    result['team_100'] = team_100
    result['team_200'] = team_200
    return result


def getParticipantsId(identities):
    participants_ids = {}
    for id_info in identities:
        participants_ids[id_info['participantId']] = id_info['player']['summonerId']
    return participants_ids


def getWinnerTeam(teams):
    result = {}
    for team in teams:
        result[team['teamId']] = team['winner']
    if result[100]:
        return 100
    else:
        return 200


def storeMatchInfo(match):
    match_info = [match['matchId'], match['duration'], match['winner'], match['team_100'],match['team_200']]
    executeQueries([createSqlString("matches", match_info)])
