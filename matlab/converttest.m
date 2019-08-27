
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
num_inputtype=3;
%simulation_2018-12-19_22-23 numpy 100 x 100\simulation_2018-12-19_22-23
path='C:\Users\Noah Workstation\Desktop\P_PR_1\repo\attentionNN\lidar\simulator\logs\simulation_2019-02-23_10-30\';
%path='C:\Users\Anton Campbell\Documents\School\5th Year, 1st Term\ELEC_4908\Results\simulation_2018-12-02_13-54\';%FIXME: update with path
%path='C:\Users\Anton Campbell\Documents\School\5th Year, 1st Term\ELEC_4908\Results\simulation_2018-11-26_21-45\';%FIXME: update with path
%path='C:\Users\Anton Campbell\Documents\School\5th Year, 1st Term\ELEC_4908\Results\simulation_2018-11-08_15-45\';%FIXME: update with path



Sim_Data=zeros(num_frames,num_inputtype,edge_size,edge_size);

for sim=1:num_sims
    for frame=1:num_frames

        %I1 = imread(strcat(path,'velocityMatrix\simulation_',num2str(sim),'\frame_V',num2str(frame-1),'.jpg')); %FIXME: provide valid path
        %I2 = im2double(I1);%velcity
        I2=readNPY(strcat(path,'velocityMatrix_numpy\simulation_',num2str(sim),'\frame_V',num2str(frame-1),'.npy'));

        %J1 = imread(strcat(path,'depthMatrix\simulation_',num2str(sim),'\frame_D',num2str(frame-1),'.jpg')); %FIXME: provide valid path         J2 = im2double(J1);
        J2 = readNPY(strcat(path,'depthMatrix_numpy\simulation_',num2str(sim),'\frame_D',num2str(frame-1),'.npy'));
                         %   'simulation_2018-12-19_22-23 numpy 100 x 100\simulation_2018-12-19_22-23\depthMatrix_numpy\simulation_1\frame_D85.npy';
        %strcat(path,'depthMatrix_numpy\simulation_',num2str(sim),'\frame_D',num2str(frame-1),'.npy','/n') 
        %A1 = imread(strcat(path,'answerMatrix\simulation_',num2str(sim),'\frame_D',num2str(frame-1),'.jpg')); %FIXME: provide valid path
        %A2 = im2double(A1);
         A2 = readNPY(strcat(path,'answerMatrix_numpy\simulation_',num2str(sim),'\frame_A',num2str(frame-1),'.npy'));


        Vx=I2(:,:,1);
        Vy=I2(:,:,2);

        Vl=sqrt(Vx.^2+Vy.^2);
        Vz=I2(:,:,3);
        Dz=J2(:,:); %FIXME: invert?
        An=A2(:,:,1);
        Dz=double(Dz);

        a=Vl;
        if(max(max(Sim_Data(frame,1,:,:)))>250)
%             pause(1)
%             w(:,:)=Sim_Data(frame,1,:,:);
%             surf(J2)
            
        end   
        figure(8)
        b=abs(Vz)./Dz;
        figure(1)
        surf(An)
        title('answer')
        figure(2)
        surf(Dz)
        figure(3)
        surf(Vz)
        figure(4)
        surf(Vl)
        figure(5)
        surf(a)
        title('V lat')
        figure(6)
        surf(b)
        title('Vz/d')
        
        figure(7)
        surf(b./15+a/100)
%         Sim_Data(frame,3,:,:)=Vz*Dz;
%         Sim_Data(frame,4,:,:)=(Vz./Dz).^2;
%         Sim_Data(frame,5,:,:)=(Vz./Dz).^3;
        
        [row, col]=size(An);
        
        for m=1:row
            for n=1:col
               
                if(abs(Dz(m,n)-255)<2)
                
                    Sim_Data(frame,3,m,n)=0;
                    
                    iswall(frame,m,n)=1;
                
                else
                  
                    Sim_Data(frame,3,m,n)=An(m,n);
                    
                    iswall(frame,m,n)=0;
                    
                end
                
            end
            
        end
        
        
        
        
        
        for L=1:3
            
            for r=1:100
                
                for c=1:100
                    
                    if(isnan(Sim_Data(frame,L,r,c))||isinf(Sim_Data(frame,L,r,c)))
                        Sim_Data(frame,L,r,c)
                        
                        Sim_Data(frame,L,r,c)=0
                        
                    end
       
                end
                
            end
   
       end

        
    end

    save(strcat('testsim/sim_',num2str(sim)),'Sim_Data','iswall','-v7.3');
   
    
end