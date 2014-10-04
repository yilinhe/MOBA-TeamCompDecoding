__author__ = 'yilinhe'

import sqlite3
conn = sqlite3.connect('lol.db');

def createTables():
    c = conn.cursor()

    # Create PLAYER table
    tableStr = '''CREATE TABLE players(pid INTEGER, name TEXT, division TEXT, PRIMARY KEY (pid));'''
    c.execute(tableStr);

    # create game table
    # create participation table
    # create player history table