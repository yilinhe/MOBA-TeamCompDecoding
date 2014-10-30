clear
clc
%read in data and random shuffle to get the test data
inputY = csvread('dotaLabel.csv');
inputX = csvread('dotaFeature.csv');
% useful info
numData = size(inputX, 1);
featDim = size(inputX, 2);

% dataset check
if numData ~= size(inputY, 1)
    error('liang', 'input data not valid!');
end

% SET THE PARAMETERS HERE
DATA_SHUFFLE = true;    % whether to shuffle the data (may be costful)
testset_ratio = 0.2;    % ratio of the testset in testset + trainingset
nIter = 10; %number of iteration

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


%%
%%%the parameter has following meanings: 
    %  number of nodes on each layer, from input layer to output layer
    %  the backprobogation method
    %  Backprop weight/bias learning function
    %  Performance function
trainData = TrainX';
targetData = TrainY';
PR = ones(108, 2);
PR(:, 1) = -1;
net = newff(PR, [72,72,1], {'tansig' 'tansig' 'tansig'},'trainlm','learngdm','mse');
net = configure(net,trainData,targetData);
net = init(net);
%%%define the weight of data test and validation
%net.divideParam.trainRatio = .6;
%net.divideParam.valRatio = .2;
%net.divideParam.testRatio = .2;
%%%set the training parameters
net.trainParam.epochs =1000;	%(Max no. of epochs to train) [100]
net.trainParam.goal =0.01;		%(stop training if the error goal hit) [0]
net.trainParam.lr =0.001;		%(learning rate, not default trainlm) [0.01]
net.trainParam.show =1;		%(no. epochs between showing error) [25]
net.trainParam.time =1000;	%(Max time to train in sec) [inf]

%%
%set the number of 
net.trainParam.showWindow = 1;
rmse = [];
t = [];
for i=1:nIter       %
    net = init(net);               % initialize network weights

    tic
    net = train(net,trainData,targetData);       % train
    predicted = sim(net, testX');      % test
    t(i) = toc;

    r = (testY' - predicted);         % residuals
    rmse(i) = sqrt(mean(r.^2));    % root mean square error
end

% plot errors and elapsed times
bar([t; rmse]', 'grouped'), xlabel('Runs')
legend({'Elapsed Time' 'RMSE'}, 'orientation','horizontal')
