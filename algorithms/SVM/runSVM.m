% automatic testing script for support vector machine
% author: ~clian~
%clear all;clc;
function res = runSVM(sss)
% load data: seems lol feature is not working
inputX = csvread('../../data/newFeat.csv');
inputY = csvread('../../data/label.csv');

% useful info
numData = size(inputX, 1);
featDim = size(inputX, 2);

% dataset check
if numData ~= size(inputY, 1)
    error('SVM: input data not valid!');
end

% SET THE PARAMETERS HERE
DATA_SHUFFLE = true;    % whether to shuffle the data (may be costful)
testset_ratio = 0.1;    % ratio of the testset in testset + trainingset


% shuffle the input data (if specified)
XTrain = zeros(numData, featDim);
YTrain = zeros(numData, 1);

if DATA_SHUFFLE == true
    randSeq = randperm(size(inputY,1));
    
    for i = 1:length(randSeq)
        XTrain(i,:) = inputX(randSeq(i),:);
        YTrain(i,:) = inputY(randSeq(i),1);
    end
else
    XTrain = inputX;
    YTrain = inputY(:,1);
end

XTrain = XTrain(1: sss,:);
YTrain = YTrain(1: sss,:);

% create the test set
numData = sss;
numTrainData = floor(numData * (1 - testset_ratio));
TestX = XTrain(numTrainData+1:numData,:);
TestY = YTrain(numTrainData+1:numData,:);

TrainX = XTrain(1:numTrainData,:);
TrainY = YTrain(1:numTrainData,:);

% train SVM with different kinds of kernels
%model = svmtrain(TrainX,TrainY);
model = svmtrain(TrainY,TrainX,'-h 0 -t 2 -g 0.07 -b 0.01');

% not finish including libsvm now
%predict_label_train = svmclassify(model, TrainX);

[predict_label_L, accuracy_L, dec_values_L] = svmpredict(TestY, TestX, model);
end



