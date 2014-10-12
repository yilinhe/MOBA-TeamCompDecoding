__author__ = 'yilinhe'

import sqlite3

conn = sqlite3.connect('lol.db')
c = conn.cursor()


def store_match(match):
    sqls = []
    # Store basic match infos
    match_info = ["matchId", "matchCreation", "matchDuration", "matchMode", "matchType", "matchVersion", "queueType",
                  "region", "season"]
    info_list = []
    for info_key in match_info:
        info_list += [match[info_key]]
    match_sql_str = create_sql_string('matches', info_list)
    # print match_sql_str
    sqls +=[match_sql_str]

    # Store the participants info relates to this match
    participants = match['participants']
    p_info_keys = ['championId', 'teamId', 'stats']

    # the a participantId to summonerId mapping
    id_dict = get_participant_ids(match['participantIdentities'])
    winner = get_winner_team(match['teams'])
    team_100 = [winner[100]]
    team_200 = [winner[200]]

    # store the participantion
    for p in participants:
        if p['teamId'] == 100:
            team_100 += [p['championId']]
        else:
            team_200 += [p['championId']]
        # playerid,matchid,champId,tid,info
        p_info_list = [id_dict[p['participantId']], match['matchId'], winner[p['teamId']]]
        for key in p_info_keys:
            p_info_list += [p[key]]
        participation_sql_str = create_sql_string("participations", p_info_list)
        # print participation_sql_str
        sqls +=[participation_sql_str]

    if match['queueType'] == "RANKED_SOLO_5x5" \
            or match['queueType'] == "NORMAL_5x5_BLIND" \
            or match['queueType'] == "NORMAL_5x5_DRAFT" \
            or match['queueType'] == "GROUP_FINDER_5x5" \
            or match['queueType'] == "RANKED_TEAM_5x5" \
            or match['queueType'] == "RANKED_SOLO_5x5":
        print_champion_info(match['matchId'], team_100, team_200)

    for sql in sqls:
        c.execute(sql)
    conn.commit()


def print_champion_info(id, team_100, team_200):
    result = 'ID:' + str(id)
    if team_100[0]:
        winner = '100'
    else:
        winner = '200'
    result += ' WIN:' + winner
    for champ in team_100[1:]:
        result += ' HERO:' + str(champ) + ':100'
    for champ in team_200[1:]:
        result += ' HERO:' + str(champ) + ':200'
    print result


def create_sql_string(table_name, info_list):
    sql_str = "INSERT INTO " + table_name + " VALUES (\'" + str(info_list[0]) + "\'"
    for info in info_list[1:]:
        sql_str += ", \'"
        value = str(info).replace('\'', '\"')
        sql_str += value
        sql_str += "\'"
    sql_str += ')'
    return sql_str


def get_participant_ids(identities):
    participants_ids = {}
    for id_info in identities:
        participants_ids[id_info['participantId']] = id_info['player']['summonerId']
    return participants_ids


def get_winner_team(teams):
    result = {}
    for team in teams:
        result[team['teamId']] = team['winner']
    return result