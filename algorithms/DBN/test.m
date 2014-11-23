clear all;clc;
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);


%%  train a DBN with (pre-training and fintuning)
rand('state',0);
% Pre-training
fprintf('Pre-training\n');

%train dbn as rbm
dbn.sizes = [100 100 100 100];
opts.numepochs =   2;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);

%unfold dbn to nn
nn = dbnunfoldtonn(dbn, 10);
nn.activation_function = 'sigm';

fprintf('Fine-tune\n');
%train nn
opts.numepochs =  20;
opts.batchsize = 100;
opts.output = 'softmax';
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);

test_error=er
