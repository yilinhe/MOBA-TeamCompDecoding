% automatic testing script for logistic regression
% author: ~jk~
clear all;clc;

% load data
inputX = csvread('lolFeature.csv');
inputY = csvread('lolLabel.csv');

% useful info
numData = size(inputX, 1);
featDim = size(inputX, 2);

% dataset check
if numData ~= size(inputY, 1)
    error('liang', 'input data not valid!');
end

% SET THE PARAMETERS HERE
alpha = 0.002;          % learning rate
numIter = 100;          % iteration time
w0 = zeros(featDim, 1); % initial weight w
DATA_SHUFFLE = true;    % whether to shuffle the data (may be costful)
testset_ratio = 0.2;    % ratio of the testset in testset + trainingset


% shuffle the input data (if specified)
XTrain = zeros(numData, featDim);
YTrain = zeros(numData, 1);

if DATA_SHUFFLE == true
    randSeq = randperm(size(inputY,1));
    
    for i = 1:length(randSeq)
        XTrain(i,:) = inputX(randSeq(i),:);
        YTrain(i,:) = inputY(randSeq(i),:);
    end
else
    XTrain = inputX;
    YTrain = inputY;
end


% create the test set
numTrainData = floor(numData * (1 - testset_ratio));
TestX = XTrain(numTrainData+1:numData,:);
TestY = YTrain(numTrainData+1:numData,:);

TrainX = XTrain(1:numTrainData,:);
TrainY = YTrain(1:numTrainData,:);


% Training logistic classifier
w = LRTrain( TrainX, TrainY, alpha, numIter, w0);


% classification on the test set
numTestSample = size(TestY,1);
count = 0;

for i = 1:length(TestY)
    if Sigmoid(TestX(i,:), w) > 0.5
        label = 0;
    else
        label = 1;
    end
    
    if label == TestY(i)
        count = count + 1;
    end
end

correct_ratio = count / numTestSample
