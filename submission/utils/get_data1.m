function [acc_gyro] = get_data1(path)
% By Yiren Lu at University of Pennsylvania
% Feb 25 2016
% ESE 650 Project 3

% this function read the data into desirable format

dataset = tsvread(path);
ts = dataset(:, 1)'/1000;
acc = dataset(:,2:4)';
gyro = dataset(:,5:7)';
acc_gyro = [acc' gyro'];
