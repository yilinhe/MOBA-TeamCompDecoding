function [ acc_train, acc_test ] = runLR( inputY, inputY, test_samples, alpha, numIter, w0)

% useful info
numData = size(inputX, 1);
featDim = size(inputX, 2);

% dataset check
if numData ~= size(inputY, 1)
    error('liang', 'input data not valid!');
end


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

acc_test = count / numTestSample

% classification on the train set
numTestSample = size(TrainY,1);
count = 0;

for i = 1:length(TrainY)
    if Sigmoid(TrainX(i,:), w) > 0.5
        label = 0;
    else
        label = 1;
    end
    
    if label == TrainY(i)
        count = count + 1;
    end
end

acc_train = count / numTestSample

return [acc_train,acc_test]