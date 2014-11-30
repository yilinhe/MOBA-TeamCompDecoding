import sys
import numpy
import matplotlib.pyplot as plt
import pylab as P

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
def convertRow(row, arrayK, arrayD, arrayA):
    feature = [0] * 108
    info = row.split(' ')
    if info[1] == 'WIN:radiant':
        winner = [0]
    else:
        winner = [1]
    tk = []
    td = []
    ta = []
    for hero_picks in info[2:7]:
        hero = hero_picks.split(':')
        if len(hero) == 5:
            kda = [int(i) for i in hero[4].split("_")]
            tk.append(kda[0])
            td.append(kda[1])
            ta.append(kda[2])
        arrayK.append(sum(tk))
        arrayD.append(sum(td))
        arrayA.append(sum(ta))

def convertFile(input, outputX, outputY):
    f = open(input)
    arrayK = []
    arrayD = []
    arrayA = []
    # first line is label
    data = f.readlines()
    f.close()
    cnt = 0
    for row in data:
        convertRow(row, arrayK, arrayD, arrayA) 
    fig, ax = plt.subplots(3, 1)
    plt.xlim(0,100)
    ax[0].hist(arrayK, bins=80)
    ax[1].hist(arrayD, bins=80)
    ax[2].hist(arrayA, bins=80)
    plt.show()
    hk,ek = numpy.histogram(arrayK, bins = 80)
    hd,ed = numpy.histogram(arrayD, bins = 80)
    ha,ea = numpy.histogram(arrayA, bins = 80)
    #hd,ed = numpy.histogram(arrayD, bins = 40)
    #ha,ea = numpy.histogram(arrayA, bins = 40)
    print hk
    print hd 
    print ha
    #print ek
    #plt.plot(hk,ek)
 #   plt.plot(hk)
 #   plt.hist(hd,bins=10)
 #   plt.hist(ha,bins=10)

# This function will take the first argument as input file, then convert it to feature and labels. The outcome
# are stored under data folder
def main(sourceLv2, sourceLv3):
    feature = "%sFeature.csv"%(sourceLv2)
    label = "%sLabel.csv"%(sourceLv2)
    convertFile(sourceLv2, feature, label)

    feature = "%sFeature.csv"%(sourceLv3)
    label = "%sLabel.csv"%(sourceLv3)
    convertFile(sourceLv3, feature, label)

    print "Program Succeeded"
    print "Output files are stored in", feature, label

# run this function by calling
# $ python DotaFeatureConverter.py ../data/dota2_match.data
if __name__ == "__main__":
   main(sys.argv[1], sys.argv[2])
   #main()
