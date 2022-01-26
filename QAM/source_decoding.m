function [u_hat]=source_decoding(l_x,b_hat_buf,code_tree,switch_off)

if switch_off==1


u_hat=reshape(b_hat_buf,[],8)


else

u_hat=[];   

%converting to two dimension

ct1=code_tree{:,:,1};
ct2=code_tree{:,:,2};
ct3=code_tree{:,:,3};
ct4=code_tree{:,:,4};
ct5=code_tree{:,:,5};

buf=[];




for i=1:1:l_x(1)
    
buf=[buf b_hat_buf(i)];  
                        
for j=1:1:(length(ct1))                                           
if(isequal(buf,ct1{j,2}))  
u_hat=[u_hat ct1{j,1}];
buf=[];
break
end                          
end   
end


for(i=l_x(1)+1:1:l_x(1)+l_x(2))
    
buf=[buf b_hat_buf(i)];  
                        
for j=1:1:(length(ct2))                                           
if(isequal(buf,ct2{j,2}))  
u_hat=[u_hat ct2{j,1}];
buf=[];
break
end                          
end   
end

for(i=l_x(1)+l_x(2)+1:1:l_x(1)+l_x(2)+l_x(3))
    
buf=[buf b_hat_buf(i)];  
                        
for j=1:1:(length(ct3))                                           
if(isequal(buf,ct3{j,2}))  
u_hat=[u_hat ct3{j,1}];
buf=[];
break
end                          
end
end

for(i=l_x(1)+l_x(2)+l_x(3)+1:1:l_x(1)+l_x(2)+l_x(3)+l_x(4))
    
buf=[buf b_hat_buf(i)];  
                        
for j=1:1:(length(ct4))                                           
if(isequal(buf,ct4{j,2}))  
u_hat=[u_hat ct4{j,1}];
buf=[];
break
end                          
end 
end

for(i=l_x(1)+l_x(2)+l_x(3)+l_x(4)+1:1:l_x(1)+l_x(2)+l_x(3)+l_x(4)+l_x(5))
    
buf=[buf b_hat_buf(i)];  
                        
for j=1:1:(length(ct5))                                           
if(isequal(buf,ct5{j,2}))  
u_hat=[u_hat ct5{j,1}];
buf=[];
break
end                          
end
end



u_hat=u_hat';


u_hat = 128*u_hat + 127;  %to avoid negative values  greater than 127 +ve values
u_hat=fix(u_hat); % to get integer value
u_hat=de2bi(u_hat,8);
end
end
