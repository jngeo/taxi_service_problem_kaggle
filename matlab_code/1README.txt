Pre-requisite:
- please download the "train.csv" and "test.csv" from the Kaggle Competition website
- https://www.kaggle.com/c/pkdd-15-predict-taxi-service-trajectory-i

Instruction:
1. If rawdata.mat does not exist. Run demoExtractRaw.m. This parses the Train.csv and Test.csv in Matlab using C++ low-level execution using mex. Output is a featuredata.mat that contains the raw data.

2. If featuredata.mat does not exist. Run demoFeatureExtract.m. This handles preprocessing and feature extraction of the data. This part prepares the data to have the correct structure for input and output of the regression model. Output is a featuredata.mat that contains the input and output feature data.

3. Run demoRegression.m. This runs all the regression models used: (1) linear regression-ordinary, (2) regularized linear regression, (3) linear regression with standardized inputs, (4) feedforward neural network.

The mean Haversine distance for predicted output of the Training and Test Dataset is displayed.

Note: processing speed may vary across dierent PCs and CPUs. This code was tested on Matlab version 2011 platform.