function d_tilde = rx_filter_sinc(s_tilde, par_rx_w, switch_graph)

 t= linspace(-8,8,49);
 srrc_lowpass_filter = sinc(t); %filter using sinc

filtered_output = conv(srrc_lowpass_filter,s_tilde);           
%Removing the delay caused by the convolution

d_tilde = filtered_output(length(srrc_lowpass_filter):par_rx_w:end-(length(srrc_lowpass_filter)-1));
% lenght of d_tilde should be equal to d at the transmitter side 

for i=1:1:length(d_tilde)
d_tilde(i:1) = d_tilde(i:1)/abs(d_tilde(i:1));
end
if switch_graph == 1
    figure('name','sinc low pass filter');
    plot(t,srrc_lowpass_filter);
    
    eyediagram(filtered_output,8);

    figure('name','Downsampled Output of the Receiver Filter');
    subplot(2,1,1)
    plot(real(d_tilde),'b')
    xlim([1 length(d_tilde)])
    grid
    title('Output of rx filter')
    legend('Real')
    
    subplot(2,1,2)
    plot(imag(d_tilde),'g')
    xlim([1 length(d_tilde)])
    grid
    legend('Img')

end


end

