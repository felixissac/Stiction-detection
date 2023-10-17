

%SIMULATING THE DATA
OP_new = zeros(1500,1);
PV_new = zeros(1500,1);
SP_new = zeros(1500,1);
MV_new = zeros(1500,1);

%slip_values = round(0.1 + (10-0.1)*rand(10,1));
%jump_values = round(0.1 + (10-0.1)*rand(10,1));

slip_values = 0.25:0.25:5;
jump_values = 0.25:0.25:5;
variance = [0.01^0.5 0.02^0.5 0.03^0.5 0.04^0.5 0.05^0.5];

l=0;

tic %To measure the time elapsed; called tic toc function 

for i=1:40
    
    display('----------------CALCUlTING---------------- ');
    
    slip = [(1:1500)' (slip_values(i))*ones(1500,1)];
    
    for j=1:40
        
        jump = [(1:1005)' (jump_values(i))*ones(1005,1)];
        
        for k=variance
            
            l = l+1;
                    
            fprintf('\n \n For Iteration : %f',l);
            
            
            fprintf('\n \n For Iteration : %f \n \n',k);
            fprintf('\n SLIP VALUE: %f',slip_values(i));
            fprintf('\n JUMP VALUE: %f',jump_values(j));
            
            var = k;
            fprintf('\n Variance: %f',var);
         
            
            sim('stictionallcasesnooscillation.mdl');
            
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
OP_s_n = OP_new(:,2:1601);
PV_s_n = PV_new(:,2:1601);
SP_s_n= SP_new(:,2:1601);
MV_s_n = MV_new(:,2:1601);
