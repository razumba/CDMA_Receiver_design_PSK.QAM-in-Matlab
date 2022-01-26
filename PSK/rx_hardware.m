function [s_tilde] = rx_hardware( y, par_rxthresh, switch_graph)
% Hard thresholding by par_rxthresh=1 value

%Converting y to polar 
R=abs(y);              
theta=angle(y);

R1=zeros(1,length(R)); %defining a matrix R1
for i=1: length(R)     
if R(i)>=par_rxthresh  
    R1(i)=par_rxthresh;
else 
    R1(i)=R(i);       
end
end

%Converting the Matrix values into cartesian cordinates
[a,b]= pol2cart(theta,R1');    
s_tilde=a+b*1i;             
                            
Diff = y-s_tilde;

if switch_graph==1
%Plotting real part of the rx_non linear hardware output   
    figure('name','Output of RX non linear hardware');
    subplot(2,1,1)
    plot(real(s_tilde),'b')     
    xlim([1 length(s_tilde)])
    ylim([-1 1])
    grid
    title('Real Part of output of RX non linear hardware')
    legend('Re')

%plotting the imaginary part of rx_non linear hardware output
    subplot(2,1,2)
    plot(imag(s_tilde),'g')     
    xlim([1 length(s_tilde)])
    ylim([-1 1])
    grid
    title('Imaginary Part of output of RX non linear hardware')
    legend('Im')

%figure to show the difference between received signal and signal after
%hardware thresholding
    figure('name','Difference of received signal and signal after hardware');
    subplot(2,1,1)
    plot(real(Diff),'b')     
    xlim([1 length(y)])
    ylim([-1 1])
    grid
    title('Real part of difference of received signal and signal after hardware')
    legend('Re')
    
    subplot(2,1,2)
    plot(imag(Diff),'g')    
    xlim([1 length(y)])
    ylim([-1 1])
    grid
    title('Imaginary part of difference of received signal and signal after hardware')
    legend('Im')
end
