clear; clc;
trainY = csvread('../data/dotaLv3Label.csv');
trainX = csvread('../data/dotaLv3Feature.csv');
nHero = size(trainX, 2);
nExample = size(trainX, 1);
matrix = zeros(nHero, nHero);

for i = 1 : nExample
    radiant = find(trainX(i,:) == 1);
    dire = find(trainX(i,:) == -1);
    for tm = 1 : length(radiant)
        for tn = 1 : length(dire)
            mm = radiant(tm);
            nn = dire(tn);
            if trainY == 0
                matrix(mm, nn) = matrix(mm, nn) + 1;
            else
                matrix(nn, mm) = matrix(nn, mm) + 1;
            end
        end
    end
end

for i = 1 : nHero
    for j = i : nHero
        ts = matrix(i, j) + matrix(j, i);
        matrix(i, j) = matrix(i,j)/ts;
        matrix(j, i) = matrix(j,i)/ts;
    end
end

for i = 1 : nHero
        matrix(i,i) = 0;
end

save('../data/dota2lv3v1.mat', 'matrix');




