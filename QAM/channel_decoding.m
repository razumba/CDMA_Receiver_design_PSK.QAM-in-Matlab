function [b_hat,ctr] = channel_decoding(c_hat, par_H, switch_off,first,itr)     

persistent ctrt;

    if first == 1 
        if itr == 1
        ctrt = [];
        end
    end
ctr1 = 0;
ctr2 = 0;
ctr3 = 0;
ctr4 = 0;
ctr5 = 0;
ctr6 = 0;
ctr7 = 0;

%H = [1 0 1 0 1 0 1; 0 1 1 0 0 1 1; 0 0 0 1 1 1 1;]; % parity-check matrix

if switch_off ==0

b_hat=[];
 for i=1:7:length(c_hat)
    if length(c_hat) >= (i+6) 
    c_temp = c_hat(i:i+6);
    syndrome = par_H*c_temp;
    syndrome = mod(syndrome,2);
    
    if(max(syndrome) > 0)
        for j = 1:length(par_H)
          if(par_H(:,j) == syndrome)
              c_temp(j) = not(c_temp(j));
           
              switch j
                case 1
                    ctr1=ctr1+1;
                case 2
                    ctr2=ctr2+1;
                case 3
                    ctr3=ctr3+1;
                case 4
                    ctr4=ctr4+1;
                case 5
                    ctr5=ctr5+1;
                case 6
                    ctr6=ctr6+1;
                case 7
                    ctr7=ctr7+1;
             end
          end
        end
    end   
    end
    b_hat = [b_hat; c_temp(1:4)];
 
 end
 
end
 ctrt =[ctrt;[ctr1 ctr2 ctr3 ctr4 ctr5 ctr6 ctr7]];
 ctr = ctrt;  
end

