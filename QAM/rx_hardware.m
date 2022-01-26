function [s_tilde] = rx_hardware( y, par_rxthresh, switch_graph)
% Hard thresholding by par_rxthresh=1 value
%Convert to polar 
R=abs(y);
theta=(angle(y));
R1=zeros(1,length(R));
for i=1: length(R)
if R(i)>=par_rxthresh % Clipping 
    R1(i)=par_rxthresh;
else 
    R1(i)=R(i);
end
end

%Convert back 
[a,b]=pol2cart(theta,R1');
s_tilde=a+b*1i;

if switch_graph==1
    
    figure('name','Hard Threshold Output');
    subplot(2,1,1)
    plot(real(s_tilde),'b')
    xlim([1 length(s_tilde)])
    ylim([-1 1])
    grid
    title('Output of rx non linear hardware')
    legend('Real')
    
    subplot(2,1,2)
    plot(imag(s_tilde),'g')
    xlim([1 length(s_tilde)])
    ylim([-1 1])
    grid
    legend('Img')
    
    Diff = y-s_tilde;
    %figure to show the difference between received signal and signal after
%hardware thresholding
    figure('name','Difference of received signal and signal after hardware');
    subplot(2,1,1)
    plot(real(Diff),'b')     
    xlim([1 length(y)])
    ylim([-1 1])
    grid
    title('Real part of difference of received signal and signal after hardware')
    legend('I')
    
    subplot(2,1,2)
    plot(imag(Diff),'g')    
    xlim([1 length(y)])
    ylim([-1 1])
    grid
    title('Imaginary part of difference of received signal and signal after hardware')
    legend('Q')

end
