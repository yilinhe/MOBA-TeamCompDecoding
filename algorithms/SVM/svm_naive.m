% automatic testing script for support vector machine
% author: ~jk~
clear all;clc;

% load data
inputX = csvread('lolFeature.csv');
inputY = csvread('lolLabel.csv');

testset_ratio = 0.2;    % ratio of the testset in testset + trainingset

numData = size(inputX, 1);
num_points = 100;
x_points = zeros(num_points,1);
train_accs = zeros(num_points,1);
test_accs = zeros(num_points,1);

for i = 1:num_points
    n = exp(log(numData*(1-testset_ratio)))*i/num_points);
    continue
    x_points(i) = n;
    train_accs(i), test_accs(i) = runSVM( inputY, inputY, test_samples);
end

plot(num_points,train_accs);