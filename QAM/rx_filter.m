function d_tilde = rx_filter(s_tilde, par_rx_w, switch_graph)

srrc_lowpass_filter = rcosine( 1, par_rx_w, 'sqrt');
% raised cosine filter

filtered_output = conv(srrc_lowpass_filter,s_tilde);      
length(filtered_output)
% Removing the delay caused by the convolution

d_tilde = filtered_output(length(srrc_lowpass_filter):par_rx_w:end-(length(srrc_lowpass_filter)-1));
% lenght of d_tilde should be equal to d at the transmitter side 

if switch_graph == 1

    eyediagram(filtered_output,8,'g');

    figure('name','Downsampled Output of the Received Square-Root-Raised-Cosine FIR Filter');
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

