function [trans emis init] = hmm_train(seq, nstate, nobs)
% By Yiren Lu at University of Pennsylvania
% Feb 21 2016
% ESE 650 Project 3

% seq           data sequence  n*1
% nstate        number of states' classes
% trans         transition matrix  n*n
% emis          emission matrix   n*n
% init          initial state distribution n*1


% epsilon T*n*n 
% epsilon(t,i,j) = (alpha(t, i) * trans(i,j) * emis(j, t+1) beta(t+1,j) ) /(
% P(O|lambda)) 

% gamma T*n
% gamma(t, i) = sum_{j=1}^n {epsilon(t,i,j)}


% estep:  estimate  epsilon and gamma
% mstep:  MLE: trans, emis, init

T = size(seq,1);
% nobs = max(seq);
n = nstate;


% aii = 0.8;
% trans = eye(n)*aii;
% for i = 1:n-1
%     trans(i, i+1) = 1-aii;
% end
% trans(n, 1) = 1-aii;
trans = rand(n,n);
trans = bsxfun(@rdivide, trans, sum(trans,2));
emis = rand(n,nobs);
emis = bsxfun(@rdivide, emis, sum(emis, 2));
init = rand(n,1);
init = init/sum(init);


epsilon = rand(T, n, n)* 1/n;
gamma  = rand(T,n) * 1/n;




max_iter = 300;
e = 10e-4;
err = 100;
iter = 0;

old = trans;

while iter< max_iter && err > e
    iter 
    % e-step:  estimate  epsilon and gamma
    [pstate alpha beta pobs] = hmm_forward_backward(trans, emis, init, n, seq);
    
    % compute epsilon
    for t = 1:T-1
        nrm = 0;
        for i = 1:n
            for j = 1:n
                nrm = nrm + alpha(t, i)*trans(i,j)*emis(j,seq(t+1))*beta(t+1,j);
            end
        end
        
        for i = 1:n
            for j = 1:n
                epsilon(t,i,j) = alpha(t, i)*trans(i,j)*emis(j,seq(t+1))*beta(t+1,j)/nrm;
            end
        end
    end
    epsilon(isnan(epsilon)) = eps;
    % compute gamma
    for t = 1:T
        for i = 1:n
            gamma(t, i) = sum( epsilon(t, i, :), 3);
        end
    end
    gamma(isnan(gamma)) = eps;
    
    % m-step: MLE parameters: trans, emis, init.
    init = gamma(1,:)';
    
    for i = 1:n
        for j = 1:n
            trans(i,j) = sum(epsilon(1:end-1,i,j),1)/sum(gamma(1:end-1, i),1);
        end
    end
    trans(isnan(trans)) = eps;
    
    for j = 1:n
        for k = 1:nobs
            emis(j,k) = sum(gamma(seq==k, j),1) / sum(gamma(:,j),1);
        end
    end
    
    emis(isnan(emis)) = eps;
    
    err = norm((trans - old));
    err
    old = trans;
    iter = iter + 1;
end
