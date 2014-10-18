__author__ = 'yilinhe'

from DBConnector import *
                
def getMatch(match_id):
    '''
    return a dictionary of match result:
    {matchId:match_id, winner:team100, team_100:{p1:champ1 ... p5:champ5}, team_200:{p1:champ1 ... p5:champ5} }
    '''

    print "getting: "+ str(match_id)
    match = w.get_match(match_id, include_timeline=False)

    # Store the participants info relates to this match
    participants = match['participants']

    # the a participantId to summonerId mapping
    id_dict = getParticipantsId(match['participantIdentities'])
    winner = getWinnerTeam(match['teams'])

    team_100 = {}
    team_200 = {}

    # store the participantion
    for p in participants:
        if p['teamId'] == 100:
            team_100[p['participantId']] = p['championId']
        else:
            team_200[p['participantId']] = p['championId']

    result = {}
    result['matchId'] = match['matchId']
    result['winner'] = winner
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
    return result

