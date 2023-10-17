
plot(normalize((OP)),'b')
%plot(OP(1:1000,:),'b')
title('Step Response')
ylabel('OP')
xlabel('time')

hold on 

plot(normalize((PV)),'r')
% plot(PV(1:1000,:),'r')

%hold on 
%plot(SP,'g')

hold off

legend('Controller Ouptut','Process vaiable','Set Point')

%%
%Tuning PID controller 
G = tf([0.615],[20 1]);
C = pidtune(G,'PI')

%%
%adding noise
L=601; %Sample length for the random signal
mu=0;
sigma=1;
X=sigma*randn(L,1)+mu;  
mysignal = PV + X;
plot(mysignal)

%%
%SIMULATING THE DATA
OP_new = zeros(1500,1);
PV_new = zeros(1500,1);
SP_new = zeros(1500,1);
MV_new = zeros(1500,1);

variance = [0 0.01^0.5 0.02^0.5 0.03^0.5 0.04^0.5 0.05^0.5];

%variance = 0.1 + (0.22-0.1).*rand(1600,1);
%slip_values = round(0.1 + (10-0.1)*rand(10,1));
%jump_values = round(0.1 + (10-0.1)*rand(10,1));


ctrl_gain = [0.8:0.02:2];
integral_gain = [0.05:0.01:0.23];

l=0;

tic %To measure the time elapsed; called tic toc function 
display('----------------CALCUlTING---------------- ');
for i=1:61
    display('NEW CONTROL GAIN LOOP');
    for j=1:19
        display('NEW INTEGRAL GAIN LOOP');
        for k = variance;
                    l = l+1;
                    
                    fprintf('\n \n For Iteration : %f',l);
                    fprintf('\n Kp Gain: %f',ctrl_gain(i));
                    fprintf('\n Integral Gain: %f',integral_gain(j));
                    
                    ctrl = ctrl_gain(i);
                    intgrl = integral_gain(j);
                    var = k;
                    fprintf('\n Variance: %f',var);
                    
                    sim('tuningvaluesmodel.mdl');
                    
                    
                    
                    
                     OP_new = [OP_new OP(1:1500)];   
                     PV_new = [PV_new PV(1:1500)];
                     SP_new = [SP_new SP(1:1500)];   
                     MV_new = [MV_new MV(1:1500)];
           
        end
    
  
             
                            
    end
    
end

display('-----------DONE--------------')

timeElapsed = toc %endinf the tic toc function 

%%
variance = [0.01^0.5 0.02^0.5 0.03^0.5 0.04^0.5 0.05^0.5];
for i = variance;
    i
end
%%
OP_s_n = OP_new(:,2:1021);
PV_s_n = PV_new(:,2:1021);
SP_s_n= SP_new(:,2:1021);
MV_s_n = MV_new(:,2:1021);
