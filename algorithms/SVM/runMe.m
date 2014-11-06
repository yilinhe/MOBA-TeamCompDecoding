% automatic testing script for support vector machine
% author: ~jk~
clear all;clc;

% load data
inputX = csvread('../../data/lolFeature.csv');
inputY = csvread('../../data/lolLabel.csv');

testset_ratio = 0.2;    % ratio of the testset in testset + trainingset

numData = size(inputX, 1);
num_points = 5;
x_points = zeros(num_points,1);
train_accs = zeros(num_points,1);
test_accs = zeros(num_points,1);
num_iteration = 3;
for i = 1:num_points
    n = 1000 + floor(exp(log((numData-1000)*(1-testset_ratio))*i/num_points));
    x_points(i) = n;
    sum1 = 0;
    sum2 = 0;
    for j = 1:num_iteration
        [t1,t2 ] = runSVM(inputX, inputY, n);
        sum1 = sum1 + t1;
        sum2 = sum2+t2;
    end
    n
    train_accs(i) = sum1/num_iteration
    test_accs(i) = sum2/num_iteration
end
x_points
train_accs
test_accs
plot(x_points,1-test_accs)