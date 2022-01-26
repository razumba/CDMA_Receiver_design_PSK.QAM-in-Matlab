function b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset,switch_graph)

% FIFO buffer
persistent tempbuffer1  %local function
if (switch_reset == 0)
    tempbuffer1 = [tempbuffer1; b_hat];
if (par_sdblklen<=length(tempbuffer1))
    b_hat_buf = tempbuffer1;
    if switch_graph== 1
    figure('name','Rx_FIFO Buffer')
    plot(b_hat_buf,'r.')
    xlim([1 length(b_hat_buf)])
    grid
    end
else
   b_hat_buf = zeros(par_fifolen,1);
end

else
     tempbuffer1 = [];                %if switch_reset is 1
     tempbuffer1 = [tempbuffer1; b_hat];
if (par_sdblklen<=length(tempbuffer1))
    b_hat_buf = tempbuffer1;
    if switch_graph== 1
    figure('name','Rx_FIFO Buffer')
    plot(b_hat_buf,'r.')
    xlim([1 length(b_hat_buf)])
    grid
    end
   
else
    b_hat_buf = zeros(par_fifolen,1);
end
   
end
end

