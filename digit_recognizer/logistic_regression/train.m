%% Kaggle | Digit Recognizer

%% Initialization
clear ; close all; clc
addpath(genpath('../../lib'));

%% =========== Part 1: Loading =============

fprintf('Loading Data\n')

X = load('../data/x.mat');
X = double(X.data);

y = load('../data/y.mat');
y = double(y.data);

%% ============ Part 2: Logistic Regression ============

fprintf('\nTraining One-vs-All Logistic Regression...\n')

lambda = 0.04;
iter_num = 200;
num_labels = 10;

[all_theta] = logisticRegression(X, y, num_labels, lambda, iter_num);

save('../data/all_theta.mat', 'all_theta');

%% ================ Part 3: Predict for One-Vs-All ================

pred = predictBylr(all_theta, X);
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);
