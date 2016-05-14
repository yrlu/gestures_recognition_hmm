% By Yiren Lu at University of Pennsylvania
% Feb 25 2016
% ESE 650 Project 3

%%
clear

% addpath
addpath ./utils



%% load model
load('model_S10_C16_good.mat', 'A','b','p');
load('kmeans_centers_16.mat', 'C');
% set parameters
nstates = 10;
nobs = 16;

%% make prediction:

% please change the directory here to the testset directory:
folder = 'test/single/';

dirstruct = dir(strcat(folder, '*.txt'));
test_set = cell(length(dirstruct),1);
paths = cell(length(dirstruct),1);
for i = 1:length(dirstruct),
    path = strcat(folder,dirstruct(i).name);
    data = get_data1(path);
    data_l = label_data(data,C);
    test_set{i} = data_l;
    paths{i} = path;
end
gestures = {'beat3','beat4','circle','eight','inf','wave'};
[maxids, maxprobs,rawlogprobs] = hmm_predict(A,b,p,nstates, test_set, gestures,paths);
% [maxids, maxprobs]
% gestures{maxids}
% y = bsxfun(@rdivide, rawlogprobs, sum(rawlogprobs,2));
% miny = min(y);
% y_after = bsxfun(@rdivide,miny, y);
% bar(y_after(:,1)/sum(y_after(:,1)));
probs = calc_prob(rawlogprobs);
bar(probs(:,1));
xlabel('Gestures')
set(gca,'xticklabel',gestures);
ylabel('Probabilties')
max(probs)
%% generate confusion matrix
% ground truth
gt = [1;1;1;1;1;2;2;2;2;2;3;3;3;3;3;4;4;4;4;4;5;5;5;5;5;6;6;6;6;6];

[cfm,order] = confusionmat(gt, maxids);
cfm = cfm/5;
plotnumeric(cfm);
xlabel('Predicted')
set(gca,'xticklabel',gestures);
ylabel('Ground Truth')
set(gca,'yticklabel',gestures);

% HeatMap(cfm);
% HeatMap(cfm, gestures, gestures, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
% heatmap(cfm, labels, labels, 1,'Colormap','red','ShowAllTicks',1,'UseLogColorMap',true,'Colorbar',true);
% imshow(cfm, 'InitialMagnification',10000)  % # you want your cells to be larger than single pixels
% colormap(jet);