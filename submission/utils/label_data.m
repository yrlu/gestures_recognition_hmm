function [acc_gyro_obs] = label_data(acc_gyro, C)
% By Yiren Lu at University of Pennsylvania
% Feb 21 2016
% ESE 650 Project 3

% acc_gyro          data n*6 
% C                 centers 

% acc_gyro_obs      n*1 labels


acc_gyro_obs = zeros(size(acc_gyro,1),1);
for i = 1:size(acc_gyro,1)
    x = acc_gyro(i,:);
    C_x = bsxfun(@minus, C, x);
    [val id] = min(diag(C_x*C_x'));
    acc_gyro_obs(i) = id;
end