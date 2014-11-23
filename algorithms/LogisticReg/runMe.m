% automatic testing script for logistic regression
% author: ~jk~
clear all;clc;

% load data
inputX = csvread('../../data/lolFeature.csv');
inputY = csvread('../../data/lolLabel.csv');

featDim = size(inputX, 2);

% SET THE PARAMETERS HERE
alpha = 0.00005;          % learning rate
numIter = 100;          % iteration time
w0 = zeros(featDim, 1); % initial weight w
testset_ratio = 0.3;    % ratio of the testset in testset + trainingset

numData = size(inputX, 1);
num_points = 30;
x_points = zeros(num_points,1);
train_accs = zeros(num_points,1);
test_accs = zeros(num_points,1);
num_iteration = 10;
for i = 1:num_points
    ratio = (i+10)/(num_points+10);
    n = 100 + floor(exp(log((numData-100)*(1-testset_ratio))*ratio));
    x_points(i) = n;
    sum1 = 0;
    sum2 = 0;
    for j = 1:num_iteration
        [t1,t2 ] = runLR(inputX, inputY, n, alpha, numIter, w0);
        sum1 = sum1 + t1;
        sum2 = sum2+t2;
    end
    n
    t1 = sum1/num_iteration
    train_accs(i) = t1;
    t2 = sum2/num_iteration
    test_accs(i) = t2;
end
x_points
train_accs
test_accs
plot(x_points, 1-train_accs, 'k', x_points, 1-test_accs, 'b');
xlabel('Number of samples');
ylabel('Error probability');
legend('Training error','Test error', 'Location','SouthEast');
xlim([100,10956]);





