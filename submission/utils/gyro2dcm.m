function [gyro_rots qd] = gyro2dcm(gyro_vals, ts)
% By Yiren Lu at University of Pennsylvania
% Feb 19 2016
% ESE 650 Project 3

% This function generates rotation matrices (DCM) and q detla from gyros
% data

% gyro_vals: 3*n matrix
% ts: 1*n time stamp in sec

% compute angles and axis
v_norm = sqrt(sum(gyro_vals.^2, 1));
dt     = ts - [ts(1), ts(1 : end - 1)];
angles   = v_norm.*dt;
axis   = bsxfun(@rdivide, gyro_vals, v_norm); 

% convert to quaternion format
qd = [cos(angles/2)' bsxfun(@times, sin(angles/2), axis)'];
q = [1 0 0 0];
gyro_rots = zeros(3, 3, size(gyro_vals,2));

for i = 1:size(gyro_vals,2)
    q = quatnormalize(quatmultiply(q, qd(i, :)));
	gyro_rots(:,:,i) = quat2dcm(q)';
end