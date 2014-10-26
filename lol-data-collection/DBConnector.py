__author__ = 'yilinhe'

import sqlite3

conn = sqlite3.connect('lol.db')
c = conn.cursor()


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
    c.execute('SELECT * FROM players WHERE playerId=?', i)
    return c.fetchone()


def getMatchFromDB(match_id):
    i = (match_id,)
    c.execute('SELECT * FROM matches WHERE matchId=?', i)
    return c.fetchone()

def getAllMatchesFromDB():
    c.execute('SELECT * FROM matches')
    return c.fetchAll()