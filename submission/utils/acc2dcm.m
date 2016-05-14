function [acc_rots] = acc2dcm(acc_vals)
% By Yiren Lu at University of Pennsylvania
% Feb 19 2016
% ESE 650 Project 3

% This function generates rotation matrices (DCM) from
% accelerometer data

% acc_vals: 3*n matrix


% generate roll pitch from acc data
r = zeros(size(acc_vals,1),1);
p = zeros(size(acc_vals,1),1);
y = zeros(size(acc_vals,1),1);

for i = 1:size(acc_vals,2)
    v = acc_vals(:,i);
    p(i) = atan2(v(1), sqrt(v(2)^2 + v(3)^2));
    r(i) = -atan2(v(2), sqrt(v(1)^2 + v(3)^2));
    y(i) = 0;
end

% generate dcm
acc_rots = rpy2rot(r,p,y);