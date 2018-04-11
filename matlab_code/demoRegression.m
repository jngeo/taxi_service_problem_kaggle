%%% demoRegression.m
%%% loads the featuredata.mat and partitions the data according to input-output, train and test data
%%% 4 types of regression methods are explored: Linear Regression - Ordinary, Linear Regression - Regularizer, 
%%%                                             Linear Regression - Standard Inputs, Feedforward neural network
%%% Required: featuredata.mat, featureNormalize.m,  
%%% see also: extractTaxiFeat

clc; clear all;
%Load feature mat data
  load('featuredata.mat');
  
%%%% 1. Linear Regression on 15 features; last feature is output
    x_tr = X_train(:,1:15);
        [mtr ntr] = size(x_tr);
    y_tr = X_train(:,24:25);
    w_tr = [ones(mtr,1) x_tr]\y_tr; %X\y
    y_tr_pred = [ones(mtr,1) x_tr]*w_tr;

    %test data
    x_ts = X_test(:,1:15);
        [mts nts] = size(x_ts);
    y_ts = X_test(:,24:25);
    y_ts_pred = [ones(mts,1) x_ts]*w_tr;

    lrTrResult_ord = mean(HaverDist(y_tr(:,1),y_tr(:,2),y_tr_pred(:,1),y_tr_pred(:,2)));    
    lrTsResult_ord = mean(HaverDist(y_ts(:,1),y_ts(:,2),y_ts_pred(:,1),y_ts_pred(:,2)));   
    
%%%% 2. Linear Regression with data standardization 
    %feature normalize [X_norm, mu, sigma]
    [X_norm, mu, sigma] = featureNormalize(X_train(:,6:25));
    x_tr = [X_train(:,1:5) X_norm(:,1:10)];
        [mtr ntr] = size(x_tr);
    y_tr = X_norm(:,19:20);
    w_tr = [ones(mtr,1) x_tr]\y_tr; %X\y
    y_tr_pred = [ones(mtr,1) x_tr]*w_tr;
        y_tr = (y_tr .* repmat(sigma(:,19:20),mtr,1)) +  repmat(mu(:,19:20), mtr,1);
        y_tr_pred = (y_tr_pred .* repmat(sigma(:,19:20),mtr,1)) +  repmat(mu(:,19:20), mtr,1);
        
    %test data
    [m n] = size(X_test);
    X_norm_ts = (X_test(:,6:25) - repmat(mu, m,1)) ./ repmat(sigma,m,1);
    x_ts = [X_test(:,1:5) X_norm_ts(:,1:10)];
        [mts nts] = size(x_ts);
    y_ts = X_norm_ts(:,19:20);
    y_ts_pred = [ones(mts,1) x_ts]*w_tr;
        y_ts = (y_ts .* repmat(sigma(:,19:20),mts,1)) +  repmat(mu(:,19:20), mts,1);
        y_ts_pred = (y_ts_pred .* repmat(sigma(:,19:20),mts,1)) +  repmat(mu(:,19:20), mts,1);
        
    lrTrResult_stand = mean(HaverDist(y_tr(:,1),y_tr(:,2),y_tr_pred(:,1),y_tr_pred(:,2)));    
    lrTsResult_stand = mean(HaverDist(y_ts(:,1),y_ts(:,2),y_ts_pred(:,1),y_ts_pred(:,2))); 
    
    
%%%% 3. Linear Regression with Regularization: varying lambda : get only the best result
    x_tr = X_train(:,1:15);
    y_tr = X_train(:,24:25);
    x_ts = X_test(:,1:15);
    y_ts = X_test(:,24:25);
        [mtr ntr] = size(x_tr);
        [mts nts] = size(x_ts);
    lambda = [0, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10];
    lrTrResult_Lambda = zeros(length(lambda),1);
    lrTsResult_Lambda = zeros(length(lambda),1);
    for i=1:length(lambda)
        [w_lambda] = trainLinearReg([ones(mtr, 1) x_tr], y_tr, lambda(i));
        w_lambda = reshape(w_lambda,16,2);
        y_tr_pred = [ones(mtr,1) x_tr]*w_lambda;
        y_ts_pred = [ones(mts,1) x_ts]*w_lambda;
        
        lrTrResult_Lambda(i,:) = mean(HaverDist(y_tr(:,1),y_tr(:,2),y_tr_pred(:,1),y_tr_pred(:,2)) ); 
        lrTsResult_Lambda(i,:) = mean(HaverDist(y_ts(:,1),y_ts(:,2),y_ts_pred(:,1),y_ts_pred(:,2)) );   
    end

%%%Print Linear regression results
    fprintf('# Mean Haversine Error for Train and Test set \n');
    fprintf('# LinearRegression-ord:[train,test]:[%d,%d]\n', lrTrResult_ord, lrTsResult_ord)
    fprintf('# LinearRegression-stand:[train,test]:[%d,%d]\n', lrTrResult_stand, lrTsResult_stand)
    fprintf('# LinearRegression-reg:[train,test]:[%d,%d]\n', min(lrTrResult_Lambda), min(lrTrResult_Lambda))
    pause;
    
%%% 4. Train neural network
    net = fitnet(30);
    net = train(net, [ones(mtr,1) x_tr]', y_tr');
    y_tr_pred = net([ones(mtr,1) x_tr]')';
    y_ts_pred = net([ones(mts,1) x_ts]')';
    
    lrTrResult_nn = mean(HaverDist(y_tr(:,1),y_tr(:,2),y_tr_pred(:,1),y_tr_pred(:,2)));    
    lrTsResult_nn = mean(HaverDist(y_ts(:,1),y_ts(:,2),y_ts_pred(:,1),y_ts_pred(:,2)));
    
%%%Print Linear regression results
    fprintf('# Mean Haversine Error for Train and Test set');
    fprintf('# FF Neural Network: [%d,%d]\n', lrTrResult_nn, lrTsResult_nn)
    
    