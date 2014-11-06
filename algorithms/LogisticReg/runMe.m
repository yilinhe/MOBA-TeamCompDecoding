% automatic testing script for logistic regression
% author: ~jk~
clear all;clc;

% load data
inputX = csvread('../../data/dotaLv3Feature.csv');
inputY = csvread('../../data/dotaLv3Label.csv');


% SET THE PARAMETERS HERE
alpha = 0.00005;          % learning rate
numIter = 200;          % iteration time
w0 = zeros(featDim, 1); % initial weight w
DATA_SHUFFLE = true;    % whether to shuffle the data (may be costful)
testset_ratio = 0.3;    % ratio of the testset in testset + trainingset

numData = size(inputX, 1);
num_points = 100;
x_points = zeros(num_points,1);
train_accs = zeros(num_points,1);
test_accs = zeros(num_points,1);

for i = 1:num_points
    n = exp(log(numData*(1-testset_ratio)))*i/num_points);
    continue
    x_points(i) = n;
    train_accs(i), test_accs(i) = runLR( inputY, inputY, test_samples, alpha, numIter, w0);
end

plot(num_points,train_accs);