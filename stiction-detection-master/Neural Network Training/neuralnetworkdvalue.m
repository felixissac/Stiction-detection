
PV = [ PV_y_5(1001:1500,2:1601) PV_y_4(1001:1500,2:1601) PV_y_3(1001:1500,2:1601) PV_y_2(1001:1500,2:1601) PV_y_1(1001:1500,2:1601) PV_n_t(1001:1500,2:2731) PV_n_o(1001:1500,2:2113)];
OP = [ OP_y_5(1001:1500,2:1601) OP_y_4(1001:1500,2:1601) OP_y_3(1001:1500,2:1601) OP_y_2(1001:1500,2:1601) OP_y_1(1001:1500,2:1601) OP_n_t(1001:1500,2:2731) OP_n_o(1001:1500,2:2113)];

Y = [ones(1,8000) zeros(1,4842); zeros(1,8000) ones(1,4842)];
%%

PV = [  PV_y_5(1001:1500,2:1601)  PV_y_4(1001:1500,2:1601) PV_n_t(1001:1500,2:3277) PV_n_o(1001:1500,2:2113)];
OP = [  OP_y_5(1001:1500,2:1601)  OP_y_4(1001:1500,2:1601) OP_n_t(1001:1500,2:3277) OP_n_o(1001:1500,2:2113)];

Y = [ones(1,3200) zeros(1,5388); zeros(1,3200) ones(1,5388)];


%%
rng default 
OP = normalize((OP));
PV = normalize((PV));
d = dvalue(OP,PV);
net = newpr(d,Y,[10 10]);
net.trainFcn = 'trainoss';    
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

%10 10 network with 2.5 had a good result 


%%
%validation for learning rate 


alpha = [0:0.1:10];
learningrate = zeros(size(alpha,2));
alpha_result = zeros(size(alpha,2),3);
for i=1:size(alpha,2)
    net = newpr(d,Y,[10 10]);
    net.trainFcn = 'trainscg'; 
    net.layers{1}.transferFcn='tansig';
    net.layers{2}.transferFcn='tansig';
    net.layers{3}.transferFcn='tansig';
    %net.trainParam.epochs = 60; %High number of iteration leads to overfitting; rather than learning it memorises 
    net.divideParam.trainRatio = 1.0; %Using the complete data for training 
    net.divideParam.testRatio = 0.0;
    net.divideParam.valRatio = 0.0;
    %net.trainParam.goal = 0.05;
    net.trainParam.lr = alpha(i);
    trainednet = train(net,d,Y);
    fprintf('\nFor the learning rate: %f', alpha(i))
    alpha_result(i,1) = alpha(i);
    
    
    nn_result_stiction = centernorm_teststiction(trainednet);
    accuracy_stiction = (nn_result_stiction/36)*100;
    nn_result_nonstiction = centernorm_testnonstiction(trainednet);
    accuracy_nonstiction = (nn_result_nonstiction/42)*100;
    
    alpha_result(i,2) = (accuracy_stiction + accuracy_nonstiction)/2; %Percentage 
    alpha_result(i,3) = nn_result_stiction + nn_result_nonstiction; %Absolute Value
    
    
    fprintf('\nCorrect number of prediction are in percentage: %f',alpha_result(i,2) )
end
%learning rate is 0.85
%net.trainParam.goal = 0.8;





%%
plot(alpha_result(:,1),alpha_result(:,2))
xlabel('Learning Rate Values','bold')
ylabel('Accuracy in %','bold')




%%
OP_value = normalize(cdata.power.loop1.OP(1:500,:));
PV_value = normalize(cdata.power.loop1.PV(1:500,:));
newinput = dvalue(OP_value,PV_value);

output = sim(trainednet, newinput)

%Function 
function p = dvalue(op,pv)
    
    p = size(op);
    sop = size(op,1);
    spv = size(pv,1);
    
    mop = (1/sop)*mean(op);
    mpv = (1/spv)*mean(pv);
    
    p = (((op - mop).^2 + (pv - mpv).^2).^(1/2));
end

