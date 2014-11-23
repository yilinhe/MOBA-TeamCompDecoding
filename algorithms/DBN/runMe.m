% automatic testing script for deep belief nets
% author: ~jk~

%% clean up
clear all; clc;

%% LOAD DATA SET

inputX = csvread('../../data/DotaLv3Feature.csv');
inputY = csvread('../../data/DotaLv3Label.csv');

% dataset size
numData = size(inputX, 1);

% dataset check
if numData ~= size(inputY, 1)
    error('input data not valid!');
end

% label create
inputYY = zeros(numData,2);
for i = 1:numData
    if inputY(i) == 0
        inputYY(i,:)=[1,0];
    else
        inputYY(i,:)=[0,1];
    end
end

%% SETUP THE PARAMETERS YOU WILL USE FOR THE NN TRAINING
input_layer_size  = size(inputX, 2)  % number of heros
DATA_SHUFFLE = true         % whether to shuffle the data (may be costful)
testset_ratio = 0.2         % ratio of the testset in testset + trainingset
                         
fprintf('Please check the parameters. Press enter to continue.\n');
pause;

%% shuffle the input data (if specified)
XTrain = zeros(numData, input_layer_size);
YTrain = zeros(numData, 2);

if DATA_SHUFFLE == true
    randSeq = randperm(numData);
    
    for i = 1:length(randSeq)
        XTrain(i,:) = inputX(randSeq(i),:);
        YTrain(i,:) = inputYY(randSeq(i),:);
    end
else
    XTrain = inputX;
    YTrain = inputY;
end

% normalization (important for DBN)
maxX = max(max(XTrain));
minX = min(min(XTrain));
XTrain = (XTrain - minX) / (maxX-minX); % TODO: should do linewise

% create the test set
numTrainData = floor(numData * (1 - testset_ratio));
test_x = XTrain(numTrainData+1:numData,:);
test_y = YTrain(numTrainData+1:numData,:);

train_x = XTrain(1:numTrainData,:);
train_y = YTrain(1:numTrainData,:);


%%  train a DBN with (pre-training and fintuning)
rand('state',0);
% Pre-training
fprintf('Pre-training\n');

%train dbn as rbm
dbn.sizes = [100 54 32];
opts.numepochs =   10;
opts.batchsize = 400;
opts.momentum  =   0.9;
opts.alpha     =   0.01;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);

%unfold dbn to nn
nn = dbnunfoldtonn(dbn, 2);
nn.activation_function = 'sigm';

fprintf('Fine-tune\n');
%train nn
opts.numepochs =  50;
opts.batchsize = 400;
opts.output = 'softmax';
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);

test_error = er