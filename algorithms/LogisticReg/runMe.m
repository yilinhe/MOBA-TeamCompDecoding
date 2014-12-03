% automatic testing script for logistic regression
% author: ~jk~
clear all;clc;

% load data
inputX = csvread('../../data/kda_10Filtered/dota2_lv3Feature.csv');
inputY = csvread('../../data/kda_10Filtered/dota2_lv3Label.csv');
%inputY = csvread('../../data/lolLabel.csv');
%inputX = csvread('../../data/lolFeature.csv');

%process lol data
%inputX(find(inputX > 0)) = 1;
%inputX(find(inputX < 0)) = -1;

featDim = size(inputX, 2);

% SET THE PARAMETERS HERE
alpha = 0.00005;          % learning rate
numIter = 100;          % iteration time
w0 = zeros(featDim, 1); % initial weight w
testset_ratio = 0.3;    % ratio of the testset in testset + trainingset

numData = size(inputX, 1);
num_points = [500 1000 2000 4000 7000 14000 22000 5000];
x_points = zeros(num_points,1);
train_accs = zeros(num_points,1);
test_accs = zeros(num_points,1);
num_iteration = 10;
for theta = 1 : size(num_points)
    num_points(theta)
    for i = 1:num_points(theta)
        ratio = (i+10)/(num_points+10);
        n = 100 + floor(exp(log((numData-100)*(1-testset_ratio))*ratio));
        x_points(i) = n;
        sum1 = 0;
        sum2 = 0;
        for j = 1:num_iteration
            %[t1,t2 ] = runLRPenalty(inputX, inputY, n, alpha, numIter, w0);
            [t1,t2 ] = runLR(inputX, inputY, n, alpha, numIter, w0);
            sum1 = sum1 + t1;
            sum2 = sum2+t2;
        end
        %n
        t1 = sum1/num_iteration;
        train_accs(i) = t1;
        t2 = sum2/num_iteration;
        test_accs(i) = t2;
    end
    x_points
    train_accs
    test_accs
end
plot(x_points, 1-train_accs, 'k', x_points, 1-test_accs, 'b');
xlabel('Number of samples');
ylabel('Error probability');
legend('Training error','Test error', 'Location','SouthEast');
xlim([100,10956]);





