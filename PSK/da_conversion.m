function a_tilde=da_conversion(u_hat,par_q,par_w,switch_graph)
Recon    =(-(2^(par_q-1)) +1 + bi2de(u_hat))/(2^(par_q-1));

a_tilde = interp(Recon,par_w);      %upsampling by factor par_w and interpolation

if switch_graph==1
    figure('name','Final Output from D/A conversion');
    stem(a_tilde)
    xlim([1 length(a_tilde)])
    ylim([-1 1])
    xlabel('Samples');
    ylabel('Amplituide');
    
    
else  
end