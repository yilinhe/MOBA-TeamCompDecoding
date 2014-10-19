__author__ = 'yilinhe'

import sqlite3

conn = sqlite3.connect('lol.db')


def createTables():
    c = conn.cursor()

    # Create players table
    tableStr = '''CREATE TABLE players(playerId LONG, pName TEXT, performance TEXT, PRIMARY KEY (playerId));'''
    c.execute(tableStr)


    # Create matches table
    tableStr = '''CREATE TABLE matches(matchId LONG, matchDuration LONG, winner TEXT, team100 TEXT, team200 TEXT, PRIMARY KEY (matchId));'''
    c.execute(tableStr)

    conn.commit()

createTables()