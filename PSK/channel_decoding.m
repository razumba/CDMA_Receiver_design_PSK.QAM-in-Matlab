function [b_hat] = channel_decoding(c_hat, par_H, switch_off)     
 
 b_hat=[];
 for i=1:7:length(c_hat)
    %if length(c_hat) >= (i+6)   %%taking 7 bits each and into a vector
    c_temp = c_hat(i:i+6);
    
   % syndrome = [];
    syndrome = par_H*c_temp;          %%%error detection
    syndrome = mod(syndrome,2);
   
    %Error Correction
    if( syndrome > 0)                     
        for j = 1:length(par_H)
          if(par_H(:,j) == syndrome)       
            c_temp(j) = not(c_temp(j));
            break;
         end
        end
    end 
    
    b_hat = [b_hat; c_temp(1:4)];                       
    
    %end
end                                                     


end
