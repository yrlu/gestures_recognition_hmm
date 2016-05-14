function [pstate alpha beta pobs] = hmm_forward_backward(trans, emis, init, nstate, seq)
% By Yiren Lu at University of Pennsylvania
% Feb 21 2016
% ESE 650 Project 3

% This function use the forward-backward algorithm to compute likelihood P(x_i, o_1, .. o_T)
% Inputs:
%   trans           transition matrix n*n
%   emis            emission matrix n*n
%   init            initial state distribution
%   nstate          n
%   seq             observation sequence, T*1

% Outputs:
%   pstate          P(x_i, o_1, .., o_T | lambda)  T*n
%   alpha           P(x_i, o_1, .., o_i )  T*n
%   beta            P(o_{i+1}, .., o_T | x_i)  T*n
%   pobs            P(o_1, .., o_T | lambda)  T*1


% The forward-backward algorithm:
%   Init:
%       a_1(x_1) = P(o_1|x_1)P(x_1), x_1 = 1..n
%       b_T(x_T) =1, x_T = 1..n
%   Forward:
%       for i = 2..T        
%       a_i(x_i) = sum_{x_{i-1}} P(o_i|x_i)P(x_i|x_{i-1})a_{i-1}(x_{i-1}),      x_i = 1..n
%   Backward:
%       for i = T-1..1
%       b_i(x_i) = sum_{x_{i+1}} P(o_{i+1}|x_{i+1})P(x_{i+1}|x_i)b_{i+1}(x_{i+1}), x_i = 1..n
%   Output:
%       for any i and x_i  
%       P(x_i, o_1, o_2, .., o_T) = a_i(x_i)b_i(x_i)
%       P(o_1, o_2, .., o_T |lambda) = sum_{x_i} P(O,x_i|lambda) = sum_{x_i} a_i(x_i)
% note that
%   P(o_i|x_j) = emis(j,seq(i))
%   P(x_j) = init(j)
%   P(x_j|x_i) = trans(i,j)

% init
n = nstate;
T = size(seq,1);
alpha = zeros(T, n);
beta = zeros(T, n);
pstate = zeros(T, n);

alpha(1,:) = bsxfun(@times, emis(:,seq(1)), init);
beta(T, :) = 1;

% forward
for i = 2:T
    for j = 1:n
        alpha(i, j) = sum( emis(j,seq(i)) *bsxfun(@times, trans(:,j), alpha(i-1, :)'));
    end
    alpha(i,:) = alpha(i,:)/sum(alpha(i,:),2); % scaling, so that the values do not underflow
    alpha(i,isnan(alpha(i,:))) = eps;
end

% backward
for i = 1:T-1
    ii = T - i;
    for j = 1:n
        beta(ii, j) = sum( bsxfun(@times, bsxfun(@times, emis(:,seq(ii+1)), trans(j,:)'),beta(ii+1, :)'));
    end
    beta(ii, :) = beta(ii,:)/sum(beta(ii,:),2); % scaling, so that the values do not underflow
    beta(ii, isnan(beta(ii,:))) = eps;
end

% compute P(x_i|O,lambda)
for i = 1:T
    for j = 1:n
        pstate(i,j) = alpha(i,j)*beta(i,j);
    end
end
alpha(isnan(alpha)) = eps;
beta(isnan(beta)) = eps;
pstate(isnan(pstate)) = eps;
% compute P(O|lambda)
% P(O|lambda) = sum_{x_i} P(O,x_i|lambda) = sum_{x_i} a_i(x_i)
pobs = sum(pstate,2);
pobs(pobs==0) = eps;