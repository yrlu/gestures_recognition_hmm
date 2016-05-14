function plot_rpy1(rots,ts)
% By Yiren Lu at University of Pennsylvania
% Feb 19 2016
% ESE 650 Project 3

% This function plot the roll pitch yaw values of rotation matrices

[r,p,y]=rot2rpy(rots);
subplot(3,1,1), plot(ts,r,'b-');
ylabel('roll');

subplot(3,1,2), plot(ts,p,'b-');
ylabel('pitch');

subplot(3,1,3), plot(ts,y,'b-');
ylabel('yaw');
end