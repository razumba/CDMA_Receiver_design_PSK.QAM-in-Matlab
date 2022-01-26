function [u_hat]=source_decoding(b_hat_buf,c_tree,switch_off,par_q,zp,l_x)

if switch_off==1;

u_hat=reshape(b_hat_buf,[],8)

else

u_hat=[];   

%Defining the code trees
ct1=c_tree{:,:,1};
ct2=c_tree{:,:,2};
ct3=c_tree{:,:,3};
ct4=c_tree{:,:,4};
ct5=c_tree{:,:,5};

buf=[];

%Mapping the codewords

for i = 1:((l_x(1,:)))
buf=[buf b_hat_buf(i)];  
                        
for j=1:1:(length(ct1))                                           
if(isequal(buf,ct1{j,2}))  
u_hat=[u_hat ct1{j,1}];
buf=[];
break
end                          
end
     
end      

for k= l_x(1,:)+1:((l_x(1,:))+(l_x(2,:)))
buf=[buf b_hat_buf(k)];  
                        
for j=1:1:(length(ct2))                                           
if(isequal(buf,ct2{j,2}))  
u_hat=[u_hat ct2{j,1}];
buf=[];
break
end                          
end
      
end 

for n= (l_x(1,:))+(l_x(2,:))+1:((l_x(1,:))+(l_x(2,:))+(l_x(3,:)))
buf=[buf b_hat_buf(n)];  
                        
for j=1:1:(length(ct3))                                           
if(isequal(buf,ct3{j,2}))  
u_hat=[u_hat ct3{j,1}];
buf=[];
break
end                          
end
      
end 


for m= (l_x(1,:))+(l_x(2,:))+(l_x(3,:))+1:((l_x(1,:))+(l_x(2,:))+(l_x(3,:))+(l_x(4,:)))
buf=[buf b_hat_buf(m)];  
                        
for j=1:1:(length(ct4))                                           
if(isequal(buf,ct4{j,2}))  
u_hat=[u_hat ct4{j,1}];
buf=[];
break
end                          
end
      
end 

for p= (l_x(1,:))+(l_x(2,:))+(l_x(3,:))+(l_x(4,:))+1:(length(b_hat_buf)-zp)
buf=[buf b_hat_buf(p)];  
                        
for j=1:1:(length(ct5))                                           
if(isequal(buf,ct5{j,2}))  
u_hat=[u_hat ct5{j,1}];
buf=[];
break
end                          
end
      
end 
u_hat=u_hat';

u_hat = (2^(par_q-1)*(u_hat) + (2^(par_q-1)-1));  %to avoid negative values 

u_hat=de2bi(u_hat,8);  %converting to binary
end
