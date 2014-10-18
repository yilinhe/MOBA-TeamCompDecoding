__author__ = 'yilinhe'

import sqlite3

conn = sqlite3.connect('lol.db')
c = conn.cursor()


def createTables():
    c = conn.cursor()

    # Create players table  
    tableStr = '''CREATE TABLE playerId(playerId LONG, pName TEXT, performance TEXT PRIMARY KEY (playerId));'''
    c.execute(tableStr);

    # Create matches table
    tableStr = '''CREATE TABLE matches(matchId LONG, matchCreation LONG, matchDuration LONG, matchMode TEXT, matchType TEXT, matchVersion TEXT, queueType TEXT, region TEXT, season TEXT, PRIMARY KEY (matchId));'''
    c.execute(tableStr);        

    # Create particitation table
    tableStr = '''CREATE TABLE participations(playerId LONG, matchId LONG, win BOOLEAN, champId INTEGER, tid INTEGER, info TEXT, PRIMARY KEY (playerId, matchId));'''
    c.execute(tableStr);

    conn.commit()

def createSqlString(table_name, info_list):
    sql_str = "INSERT INTO " + table_name + " VALUES (\'" + str(info_list[0]) + "\'"
    for info in info_list[1:]:
        sql_str += ", \'"
        value = str(info).replace('\'', '\"')
        sql_str += value
        sql_str += "\'"
    sql_str += ')'  
    return sql_str

def executeQueries(sqls):
    for sql in sqls:
        c.execute(sql)
    conn.commit()


def getPlayerFromDB(player_id):
    i = (player_id,)
    c.execute('SELECT * FROM players WHERE playerId=?',i)
    return c.fetchone()


def getMatchFromDB(match_id):
    i = (match_id,)
    c.execute('SELECT * FROM matches WHERE matchId=?',i)
    return c.fetchone()