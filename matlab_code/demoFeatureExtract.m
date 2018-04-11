%%% demoFeatureExtract.m
%%% does feature extraction: taxi ID, trip type, week_of_the_year, day_of_the_week, quarter_hour_of_the_day, 5 initial GPS, 5 last GPS
%%% input dimension: 15 
%%% output dimension: 2
%%% Required: rawdata.mat, extractTaxiFeat.m, unixtime_to_datenum.m
%%% see also: extractTaxiFeat

clc; clear all;
%Load mat data
  load('rawdata.mat');
  rawTest = rawTest([2:end],:);                               %remove first row of test data: just variable names

%Preprocess data: 
%Extract features
    [m n] = size(rawTrain);
    [mts nts] = size(rawTest);
    [rawDataTs buffTs ts_feat_time ts_feat_raw ts_feat_poly] = extractTaxiFeat(rawTest);
    [rawDataTr buffTr tr_feat_time tr_feat_raw tr_feat_poly] = extractTaxiFeat(rawTrain);
    
    X_test = [ts_feat_raw ts_feat_poly];
    X_train = [tr_feat_raw tr_feat_poly];
    
    save('featuredata.mat','X_train','X_test');   
    
    
    