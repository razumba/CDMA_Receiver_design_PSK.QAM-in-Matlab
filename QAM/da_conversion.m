function a_tilde=da_conversion(u_hat,par_w,par_q,switch_graph)
[m,n]  = size(u_hat);
M    =(-(2^(par_q-1)) +1 + bi2de(u_hat))/(2^(par_q-1)-1);
a_tilde = zeros(par_w*m,1);

a_tilde(1:par_w:end) = M;

t= linspace(-1.2,1.2,49); 
y_sinc = sinc(t);

a_tilde = conv(a_tilde,y_sinc);

a_tilde = a_tilde(25:end-24)/max(a_tilde);

if switch_graph==1
    
    figure('name','D/A output');
    xlabel('Samples');
    ylabel('Amplituide');
    plot(a_tilde)
    xlim([1 length(a_tilde)])
    ylim([-1 1])
    hold on
    stem(1:length(a_tilde),a_tilde,'g')
else  
end