function [maxids,maxprobs,rawlogprobs] = hmm_predict(A,b,p, nstates, test_set,labels, items)
% By Yiren Lu at University of Pennsylvania
% Feb 25 2016
% ESE 650 Project 3
maxids = [];
maxprobs = [];
rawlogprobs = [];
for i = 1:length(test_set)
    
    test_data = test_set{i};
    maxprob = -Inf;
    maxid = -1;
    logprobs = [];
    for j = 1:6
        [~,~,~,prob] = hmm_forward_backward(A{j},b{j},p{j},nstates,test_data);
        logprob = sum(log(prob));
        if logprob > maxprob
            maxprob = logprob;
            maxid = j;
        end
        logprobs = [logprobs;logprob];
    end
    ploty = (1-logprobs/sum(logprobs))/sum(1-logprobs/sum(logprobs));
    maxprobs = [maxprobs;ploty(maxid)];
    maxids = [maxids;maxid];
    rawlogprobs = [rawlogprobs,logprobs];
    disp(sprintf('Predicting %d/%d %s : %s',i, length(test_set),items{i},labels{maxid})); 
end


%


% maxids
