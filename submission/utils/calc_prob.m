function [probs] = calc_prob(rawlogprobs)
% By Yiren Lu at University of Pennsylvania
% Feb 25 2016
% ESE 650 Project 3
y = bsxfun(@rdivide, rawlogprobs, sum(rawlogprobs,1));
miny = min(y);
y_after = bsxfun(@rdivide,miny, y);
probs = bsxfun(@rdivide, y_after,sum(y_after));
