%%                              Neural Network for PCA

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