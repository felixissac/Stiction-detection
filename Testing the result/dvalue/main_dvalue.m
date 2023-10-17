
load('ChoudhuryData.mat')

PV = [  PV_y_5(1001:1500,2:1601)  PV_y_4(1001:1500,2:1601) PV_n_t(1001:1500,2:3277) PV_n_o(1001:1500,2:2113)];
OP = [  OP_y_5(1001:1500,2:1601)  OP_y_4(1001:1500,2:1601) OP_n_t(1001:1500,2:3277) OP_n_o(1001:1500,2:2113)];

Y = [ones(1,3200) zeros(1,5388); zeros(1,3200) ones(1,5388)];


%%
rng default 
OP = normalize((OP));
PV = normalize((PV));
d = dvalue(OP,PV);
net = newpr(d,Y,[10 10]);
net.trainFcn = 'trainscg';    
%net.trainParam.epochs = 2000;
net.layers{1}.transferFcn='tansig';
net.layers{2}.transferFcn='tansig';
net.layers{3}.transferFcn='tansig';
net.divideParam.trainRatio = 1.0; %Using the complete data for training 
net.divideParam.testRatio = 0.0;
net.divideParam.valRatio = 0.0;
%net.trainParam.lr = 7.8;
%net.trainParam.goal=1e-8;
%net.performFcn='msereg';  Dosent really make a difference
%net.performParam.ratio=0.5; Dosent really make a difference 
trainednet = train(net,d,Y);

%% 
%Testing on sticiton loops
nn_result_stiction = centernorm_teststiction(trainednet);
accuracy_stiction = (nn_result_stiction/36)*100;
fprintf('\n For Sticiton Loops');
fprintf('\n Correct Prediction: %f ', nn_result_stiction);
fprintf('\n Prediction Accuracy: %f percent', accuracy_stiction);

%for tansig lr=1.7 param.gaol=0.07 epoch=60


%Testing on non sticiton loops

nn_result_nonstiction = centernorm_testnonstiction(trainednet);
accuracy_nonstiction = (nn_result_nonstiction/42)*100;
fprintf('\n For NON - Sticiton Loops')
fprintf('\n Correct Prediction: %f ', nn_result_nonstiction);
fprintf('\n Prediction Accuracy: %f percent', accuracy_nonstiction);
fprintf('\n  Total Prediction Accuracy: %f percent', (accuracy_stiction+accuracy_nonstiction)/2);
fprintf('\n  \n \n')

%for tansig lr=1.7 param.gaol=0.07 epoch=60



%%
%Function
function p = dvalue(op,pv)
    
    p = size(op);
    sop = size(op,1);
    spv = size(pv,1);
    
    mop = (1/sop)*mean(op);
    mpv = (1/spv)*mean(pv);
    
    p = (((op - mop).^2 + (pv - mpv).^2).^(1/2));
end

