%%% demoExtractRaw.m
%%% Parses the raw csv file into a .mat file in Matlab using swallow_csv which is a C++ compiled using command mex
%%% see also: mex -setup
%%% Required: train.csv, test.csv, swallow_csv

clc; clear all; close all;
format long;                    %maintain long precision of fixed point

%Taxi Dataset
%Load data
    quote = '"'; sep = ';'; escape = '\';
    [numbers, text] = swallow_csv('train.csv', quote, sep, escape);     %1,710,671 samples 
    [numTest, textTest] = swallow_csv('test.csv', quote, sep, escape);  %      321 samples
    
%downsample train data by factor of 10
    rawTrain = text([2:10:end],:);
    rawTest = textTest;
    save('rawdata.mat','rawTrain','rawTest');    
