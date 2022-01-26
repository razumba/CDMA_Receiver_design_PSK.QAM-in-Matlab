function b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset)
% FIFO Stack
persistent tempbuffer1;
if (switch_reset == 0)
    tempbuffer1 = [tempbuffer1; b_hat];
if (par_sdblklen<=length(tempbuffer1))
    b_hat_buf = tempbuffer1;              
else
    b_hat_buf = zeros(par_fifolen,1);
end

else
     tempbuffer1 = [];
      tempbuffer1 = [tempbuffer1; b_hat];
if (par_sdblklen<=length(tempbuffer1))
    b_hat_buf = tempbuffer1;              
else
    b_hat_buf = zeros(par_fifolen,1);
end
   
end
end

