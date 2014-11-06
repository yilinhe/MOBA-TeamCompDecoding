function [ acc_train, acc_test ] = runSVM( inputY, inputY, test_samples)

% useful info
numData = size(inputX, 1);
featDim = size(inputX, 2);

% dataset check
if numData ~= size(inputY, 1)
    error('SVM: input data not valid!');
end

% SET THE PARAMETERS HERE
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

TrainX = XTrain(1:test_samples,:);
TrainY = YTrain(1:test_samples,:);

% train SVM with different kinds of kernels
model = svmtrain(TrainX,TrainY,'autoscale',true,'KERNEL_FUNCTION','rbf','boxconstraint',0.1);

% not finish including libsvm now
[predict_label_train, acc_train] = svmclassify(model, TrainX);

[predict_label_test, acc_test] = svmclassify(model, TestX);

acc_train
acc_test

end