__author__ = 'yilinhe'

import sqlite3
conn = sqlite3.connect('loldata.db');

def createTables():
    c = conn.cursor()

    # Create players table
    tableStr = '''CREATE TABLE playerId(playerId LONG, pName TEXT, division TEXT, performance TEXT PRIMARY KEY (playerId));'''
    c.execute(tableStr);


    # Create matches table
    tableStr = '''CREATE TABLE matches(matchId LONG, matchCreation LONG, matchDuration LONG, matchMode TEXT, matchType TEXT, matchVersion TEXT, queueType TEXT, region TEXT, season TEXT, PRIMARY KEY (matchId));'''
    c.execute(tableStr);


    # Create PLAYER table
    tableStr = '''CREATE TABLE matches(playerId LONG, matchId LONG, win BOOLEAN, champId INTEGER, tid INTEGER, info TEXT, PRIMARY KEY (playerId, matchId));'''
    c.execute(tableStr);

	conn.commit()