import sys

# The id was mapped differently.
# dota doesn't have champion id 24 and 108, therefore we mapped 110 to 24 and 109 to 108.
def getId(hero_id):
    if hero_id == '110':
        return 24
    if hero_id == '109':
        return 108
    return int(hero_id)


# team radiant has positive team comp feature
# team dire has negative team comp feature
# y = 0 if radiant wins, y = 1 if dire wins
def convertRow(row):
    feature = [0] * 108
    info = row.split(' ')
    if info[1] == 'WIN:radiant':
        winner = [0]
    else:
        winner = [1]
    for hero_picks in info[2:]:
        hero = hero_picks.split(':')
        if len(hero) == 5:
            kda = [int(i) for i in hero[4].split("_")]
            if kda[0] == 0 and kda[1] == 0 and kda[2] == 0:
                return None, None
        hero_id = getId(hero[1]) - 1
        team = hero[2]
        if team == 'radiant':
            feature[hero_id] = 1
        else:
            feature[hero_id] = -1
    return winner, feature


def convertFile(input, outputX, outputY):
    f = open(input)
    xf = open(outputX, 'w+')
    yf = open(outputY, 'w+')

    # first line is label
    data = f.readlines()
    f.close()
    cnt = 0
    for row in data[:-1]:
        y, x = convertRow(row)
        if x is None or y is None:
            cnt += 1
            continue
        xf.write(", ".join(str(i) for i in x) + '\n')
        yf.write(", ".join(str(i) for i in y) + '\n')
    row = data[-1]
    y, x = convertRow(row)
    if x is None or y is None:
            cnt += 1
    else:
        xf.write(", ".join(str(i) for i in x))
        yf.write(", ".join(str(i) for i in y))

    xf.close()
    yf.close()
    print "data count with 0 kda:", cnt


# This function will take the first argument as input file, then convert it to feature and labels. The outcome
# are stored under data folder
def main(argv=None):
    if argv is None:
        argv = sys.argv
    if len(argv) == 1:
        print "please provide input file as first argument"

    feature = '../data/dotaLv2Feature.csv'
    label = '../data/dotaLv2Label.csv'
    convertFile(argv[1], feature, label)

    feature = '../data/dotaLv3Feature.csv'
    label = '../data/dotaLv3Label.csv'
    convertFile(argv[2], feature, label)

    print "Program Succeeded"
    print "Output files are stored in", feature, label

# run this function by calling
# $ python DotaFeatureConverter.py ../data/dota2_match.data
if __name__ == "__main__":
   main(['thisfunction', '../data/data-by20141101-jk/level2/level2_match.data',
          '../data/data-by20141101-jk/level3/level3_match.data'])
   #main()