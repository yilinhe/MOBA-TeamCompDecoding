function [ w ] = LRTrain( XTrain, yTrain, learningRate, numIter, w0)
    
    % Train the model
    fgrad = @(w) LRgradient( XTrain, yTrain, w );
    flogl = @(w) LRlogLikelihood( XTrain, yTrain, w );

    [w] = gradDescent(flogl, fgrad, w0, learningRate, numIter);

end