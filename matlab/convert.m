
clc



clc
clear all
close all

element_size=1;
edge_num_element=100;
edge_size=element_size*edge_num_element;
x_cutoff=100;

num_sims=100;
num_frames=100;
num_inputtype=5;
path='simulation_2018-12-07_16-16\';
%path='C:\Users\Anton Campbell\Documents\School\5th Year, 1st Term\ELEC_4908\Results\simulation_2018-12-02_13-54\';%FIXME: update with path
%path='C:\Users\Anton Campbell\Documents\School\5th Year, 1st Term\ELEC_4908\Results\simulation_2018-11-26_21-45\';%FIXME: update with path
%path='C:\Users\Anton Campbell\Documents\School\5th Year, 1st Term\ELEC_4908\Results\simulation_2018-11-08_15-45\';%FIXME: update with path



SIM_DATA=zeros(num_frames,num_inputtype,edge_size,edge_size);

for sim=1:num_sims
    for frame=1:num_frames

        %I1 = imread(strcat(path,'velocityMatrix\simulation_',num2str(sim),'\frame_V',num2str(frame-1),'.jpg')); %FIXME: provide valid path
        %I2 = im2double(I1);%velcity
        %I2=readNPY(strcat(path,'velocityMatrix_numpy\simulation_',num2str(sim),'\frame_V',num2str(frame-1),'.npy'));
        I2 = readNPY("C:\Users\Noah Workstation\Desktop\P_PR_1\repo\attentionNN\lidar\simulator\logs\simulation_2018-12-07_16-16\velocityMatrix_numpy\simulation_2\frame_V0.npy");
        %J1 = imread(strcat(path,'depthMatrix\simulation_',num2str(sim),'\frame_D',num2str(frame-1),'.jpg')); %FIXME: provide valid path         J2 = im2double(J1);
        %J2 = readNPY(strcat(path,'depthMatrix_numpy/simulation_',num2str(sim),'/frame_D',num2str(frame-1),'.npy'));
        J2  =readNPY("C:\Users\Noah Workstation\Desktop\P_PR_1\repo\attentionNN\lidar\simulator\logs\simulation_2018-12-07_16-16\depthMatrix_numpy\simulation_2\frame_D0.npy");
%         
        %A1 = imread(strcat(path,'answerMatrix\simulation_',num2str(sim),'\frame_D',num2str(frame-1),'.jpg')); %FIXME: provide valid path
        %A2 = im2double(A1);
         %A2 = readNPY(strcat(path,'answerMatrix_numpy/simulation_',num2str(sim),'/frame_A',num2str(frame-1),'.npy'));
         A2 = readNPY("C:\Users\Noah Workstation\Desktop\P_PR_1\repo\attentionNN\lidar\simulator\logs\simulation_2018-12-07_16-16\answerMatrix_numpy\simulation_2\frame_A0.npy");


        Vx=I2(:,:,1);
        Vy=I2(:,:,2);

        Vl=sqrt(Vx.^2+Vy.^2)/sqrt(2);
        Vz=I2(:,:,3);
        Dz=J2(:,:,1); %FIXME: invert?
        An=A2(:,:,1);
        Dz=double(Dz);
        Inv_DZ = 1./(Dz+1e-19);

        SIM_DATA(frame,1,:,:)=1./(Dz+1e-19);
        if(max(max(SIM_DATA(frame,1,:,:)))>250)
            pause(1)
            
        end   
        SIM_DATA(frame,2,:,:)=Vl;
        SIM_DATA(frame,3,:,:)=Vz;
        SIM_DATA(frame,4,:,:)=Vz./(Dz+1e-19);
        SIM_DATA(frame,5,:,:)=An;
        
        
        for L=1:5
            
            for r=1:100
                
                for c=1:100
                    
                    if(isnan(SIM_DATA(frame,L,r,c))||isinf(SIM_DATA(frame,L,r,c)))
                        
                        SIM_DATA(frame,L,r,c)=0;
                        
                    end
       
                end
                
            end
   
       end

        
    end

    save(strcat('sims/sim_',num2str(sim)),'SIM_DATA','-v7.3');
   
    
end