from ChampionDictionary import getDict
import ast
import sys

id_dict = {'133': 69, '131': 37, '134': 28, '24': 84, '25': 12, '26': 108, '27': 115, '20': 2, '21': 5, '22': 58,
           '23': 64, '28': 0, '29': 62, '161': 31, '4': 9, '8': 18, '120': 68, '121': 33, '122': 119, '267': 26,
           '266': 13, '126': 39, '127': 54, '268': 55, '59': 90, '58': 76, '55': 71, '54': 60, '57': 81, '56': 8,
           '51': 75, '50': 3, '53': 66, '412': 83, '115': 114, '114': 49, '117': 98, '89': 118, '111': 96, '110': 92,
           '113': 112, '112': 77, '82': 107, '83': 82, '80': 99, '81': 44, '119': 14, '84': 117, '85': 32, '3': 87,
           '7': 70, '102': 102, '103': 101, '101': 113, '106': 30, '107': 95, '104': 7, '105': 93, '39': 24, '38': 16,
           '33': 109, '32': 22, '31': 6, '30': 38, '37': 17, '36': 10, '35': 11, '34': 51, '60': 41, '61': 89,
           '62': 111, '63': 78, '64': 48, '67': 43, '68': 110, '69': 19, '254': 97, '2': 23, '6': 85, '99': 47,
           '98': 72, '91': 50, '90': 21, '92': 25, '222': 74, '96': 46, '11': 104, '10': 52, '13': 34, '12': 42,
           '15': 88, '14': 40, '17': 120, '16': 91, '19': 73, '18': 86, '150': 57, '154': 67, '157': 63, '238': 1,
           '236': 105, '48': 100, '86': 36, '44': 4, '45': 94, '42': 79, '43': 116, '40': 65, '41': 27, '1': 61,
           '5': 59, '9': 45, '201': 80, '143': 106, '77': 103, '76': 15, '75': 53, '74': 56, '72': 20, '79': 35,
           '78': 29}


# used to generate id_dict. We stopped using it.
# id_dict = buildIdDict()
def buildIdDict():
    dict = getDict()
    id_dict = {}
    counter = 0
    for k, v in dict.items():
        id_dict[v['champion_id']] = counter
        counter += 1
    return id_dict

# team A has positive team comp feature
# team B has negative team comp feature
# y = 0 if team A wins, y = 1 if team B wins
def convertRow(row):
    feature = [0] * len(id_dict)
    info = row.split('|')
    if info[2] == '100':
        winner = [0,1]
    else:
        winner = [1,0]

    team1 = ast.literal_eval(info[3])
    team2 = ast.literal_eval(info[4])

    # calculate sum for normalization
    posSum = 0
    negSum = 0
    for k, v in team1.items():
        posSum += round(v + 0.01, 4)
    for k, v in team2.items():
        negSum += round(v + 0.01, 4)

    # calculate actual value
    for k, v in team1.items():
        id = id_dict[str(k)]
        feature[id] = round(v + 0.01, 4)/posSum * 5
    for k, v in team2.items():
        id = id_dict[str(k)]
        feature[id] = round(- (v + 0.01), 4)/negSum * 5
    
    return (winner, feature)


def convertFile(input, outputX, outputY):
    f = open(input)
    xf = open(outputX, 'w+')
    yf = open(outputY, 'w+')

    # first line is label
    data = f.readlines()
    f.close()

    for row in data[:-1]:
        y, x = convertRow(row)
        xf.write(", ".join(str(i) for i in x) + '\n')
        yf.write(", ".join(str(i) for i in y) + '\n')
    row = data[-1]
    y, x = convertRow(row)
    xf.write(", ".join(str(i) for i in x))
    yf.write(str(y))

    xf.close()
    yf.close()


# This function will take the first argument as input file, then convert it to feature and labels. The outcome
# are stored under data folder
def main(argv=None):
    if argv is None:
        argv = sys.argv
    if len(argv) == 1:
        print "please provide input file as first argument"
    feature = '../data/lolFeature.csv'
    label = '../data/lolLabel.csv'
    convertFile(argv[1], feature, label)
    print "Program Succeeded"
    print "Output files are stored in", feature, label

if __name__ == "__main__":
    main(['this','matches.dmp'])