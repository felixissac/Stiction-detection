close all; clc;

%%                             Loading the Data
 
load('ChoudhuryData.mat')


PV = [ PV_y_1(1001:1500,2:1601)  PV_y_4(1001:1500,2:1601) PV_y_5(1001:1500,2:1601) PV_n_t(1001:1500,2:3277) PV_n_o(1001:1500,2:2113)];
OP = [ OP_y_1(1001:1500,2:1601)  OP_y_4(1001:1500,2:1601) OP_y_5(1001:1500,2:1601) OP_n_t(1001:1500,2:3277) OP_n_o(1001:1500,2:2113)];

Y = [ones(1,4800) zeros(1,5388); zeros(1,4800) ones(1,5388)];

%%
p = pvalues_normalize(OP,PV);

%%                              Neural Network

rng default 
%p = pvalues(OP,PV);
net = newpr(p,Y,[20 20]);
net.trainFcn = 'trainscg';    
% net.trainParam.epochs = 33;   %Best Result at 33
net.layers{1}.transferFcn='tansig';
net.layers{2}.transferFcn='tansig';
net.layers{3}.transferFcn='tansig';
net.divideParam.trainRatio = 1.0; %Using the complete data for training 
net.divideParam.testRatio = 0;
net.divideParam.valRatio = 0;
%net.trainParam.lr = 7.8;
%net.trainParam.goal=1e-8;
%net.performFcn='msereg';  Dosent really make a difference
%net.performParam.ratio=0.5; Dosent really make a difference 
trainednet = train(net,p,Y);

%%                          Testing on sticiton loops
                          
nn_result_stiction = stictionloops_pca(trainednet);
accuracy_stiction = (nn_result_stiction/36)*100;
fprintf('\n For Sticiton Loops');
fprintf('\n Correct Prediction: %f ', nn_result_stiction);
fprintf('\n Prediction Accuracy: %f percent', accuracy_stiction);

%for tansig lr=1.7 param.gaol=0.07 epoch=60


%                           Testing on non sticiton loops

nn_result_nonstiction = nonstictionloops_pca(trainednet);
accuracy_nonstiction = (nn_result_nonstiction/42)*100;
fprintf('\n For NON - Sticiton Loops')
fprintf('\n Correct Prediction: %f ', nn_result_nonstiction);
fprintf('\n Prediction Accuracy: %f percent', accuracy_nonstiction);
fprintf('\n  Total Prediction Accuracy: %f percent', (accuracy_stiction+accuracy_nonstiction)/2);
fprintf('\n  \n \n')