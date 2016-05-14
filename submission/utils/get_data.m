function [acc_gyro,ts,gyro_rots,acc_rots] = get_data(path)
% By Yiren Lu at University of Pennsylvania
% Feb 21 2016
% ESE 650 Project 3

% this function read the data into desirable format



dataset = tsvread(path);
ts = dataset(:, 1)'/1000;
acc = dataset(:,2:4)';
gyro = dataset(:,5:7)';

gyro_rots = gyro2dcm(gyro,ts);
acc_rots = acc2dcm(acc);
% figure; plot_rpy2(gyro_rots,ts, acc_rots,ts, 'gyro', 'acc');
% [r,p,y] = rot2rpy(gyro_rots);
acc_gyro = [acc' gyro'];