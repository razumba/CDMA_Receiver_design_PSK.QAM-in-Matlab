function [MSE,BER]=analog_sink(a,a_tilde,b,b_hat_buf)
%Error calculation between reconstructed and original Signal
%Bit Error Rate Calculation 
BER             = sum(abs(b-b_hat_buf))/length(b);          
%Mean Square Error Calculation
MSE             = sum((a-a_tilde).^2)/length(a);