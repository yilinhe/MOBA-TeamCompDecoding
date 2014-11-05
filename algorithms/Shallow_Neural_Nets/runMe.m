% clean up
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

% label convert
inputY = inputY + 1;

%% SETUP THE PARAMETERS YOU WILL USE FOR THE NN TRAINING
input_layer_size  = size(inputX, 2)  % number of heros
hidden_layer_size = 100     % 25 hidden units
num_labels = 2              % 2 labels, indicates the winner
lambda = 0.5                % regularization const
Iteration = 50             % maximum iteration time
DATA_SHUFFLE = true         % whether to shuffle the data (may be costful)
testset_ratio = 0.3         % ratio of the testset in testset + trainingset
                         
fprintf('Please check the parameters. Press enter to continue.\n');
pause;

%% shuffle the input data (if specified)
XTrain = zeros(numData, input_layer_size);
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


%% ================ Initializing Parameters ================
fprintf('\nInitializing Neural Network Parameters ...\n')

initial_W1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_W2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_W1(:) ; initial_W2(:)];

%% =================== Training NN ===================
fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', Iteration);

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, TrainX, TrainY, lambda);

% call fmincg to optimize neural nets
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
W1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

W2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================= Prediction =================
%  Training error and test error

pred = predict(W1, W2, TrainX);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == TrainY)) * 100);

pred = predict(W1, W2, TestX);

fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == TestY)) * 100);

