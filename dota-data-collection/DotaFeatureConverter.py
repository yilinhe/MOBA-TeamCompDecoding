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
        winner = 0
    else:
        winner = 1
    for hero_picks in info[2:]:
        hero = hero_picks.split(':')
        hero_id = getId(hero[1]) - 1
        team = hero[2]
        if team == 'radiant':
            feature[hero_id] = 1
        else:
            feature[hero_id] = -1
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
        yf.write(str(y) + '\n')
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
    feature = '../data/dotaFeature.csv'
    label = '../data/dotaLabel.csv'
    convertFile(argv[1], feature, label)
    print "Program Succeeded"
    print "Output files are stored in", feature, label

# run this function by calling
# $ python DotaFeatureConverter.py ../data/dota2_match.data
if __name__ == "__main__":
    main()