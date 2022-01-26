
function d_tilde = rx_filter(d,s,s_tilde, par_rx_w, switch_graph)
%p  = tx_filter(1,par_rx_w,switch_graph);
%LPF=conj(p(end:-1:1));
%LPF=LPF(8:1:length(LPF))
%filtered_output = conv(LPF,s_tilde);
%b=length(filtered_output)
%a=length(LPF)
%d_tilde = filtered_output((length(LPF)):8:end-(length(LPF)-1));

%p=upsample(d,8);
%[q,r] = deconv(s,p);
%LPF=real(q)
%LPF=flip(LPF)
%filtered_output = conv(LPF,s_tilde);

t = linspace(-8,8,49); % define t with 49 values
LPF = sinc(t); % ideal LPF
filtered_output = conv(LPF,s_tilde); % Convolution between the filter and the signal
% size(filtered_output)
% p=1:1:500
% figure(1000)
% stem(p,filtered_output(1:500))
d_tilde = filtered_output(length(LPF):par_rx_w:end-(length(LPF)-1)); %Downsample and remove delays 

if switch_graph==1
    %figure('name', 'Filter impulse Response');
    %stem(t,LPF)
    %grid
    
    figure('name', 'Filtered output');
    subplot(2,1,1)
    plot(real(filtered_output),'b')
    xlim([1 length(filtered_output)])
    title('Real Part of Filtered Output')
    grid 
    legend('Re')
    
    subplot(2,1,2)
    plot(imag(filtered_output),'g')
    xlim([1 length(filtered_output)])
    grid 
    title('Imaginary Part of Filtered Output')
    legend('Im')

    figure('name', 'Downsampled Output of the LPF');
    subplot(2,1,1)
    plot(real(d_tilde),'b')
    xlim([1 length(d_tilde)])
    title('Real part of Downsampled Output of the LPF')
    grid 
    legend('Re')
    
    subplot(2,1,2)
    plot(imag(d_tilde),'g')
    xlim([1 length(d_tilde)])
    grid
    title('Imaginary part of Downsampled Output of the LPF')
    legend('Im')
    
    eyediagram(filtered_output,8) %16 samples per trace
end



end