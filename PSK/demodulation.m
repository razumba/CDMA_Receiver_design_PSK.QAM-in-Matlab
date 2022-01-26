function c_hat=demodulation(d_tilde,switch_mod,switch_graph)

if switch_mod==0
    %Reference points for 16 qamm
    symbol_locations=[-0.9487-0.9487i -0.9487-.3162i -0.9487+0.9487i -0.9487+.3162i -.3162-0.9487i -.3162-.3162i -.3162+0.9487i -.3162+.3162i 0.9487-0.9487i 0.9487-.3162i 0.9487+0.9487i 0.9487+.3162i +.3162-0.9487i .3162-.3162i .3162+0.9487i .3162+.3162i];
   
else
    %Reference points for 16psk 
    symbol_locations = [-0.9808 - 0.1951i;-0.8315 - 0.5556i;-0.1951 - 0.9808i;-0.5556 - 0.8315i;-0.9806 + 0.1951i;-0.8315 + 0.5556i;-0.19519 + 0.9808i;-0.5556 + 0.8315i;0.9808 - 0.1951i;0.8315 - 0.5556i;0.1951 - 0.9808i;0.5556 - 0.8315i;0.9808 + 0.1951i;0.8315 + 0.5556i;0.1951 + 0.9808i;0.5556 + 0.8315i];
end    
     %minimum distance calculation  
    for k=1:1:length(d_tilde) ,     
        for i=1:1:length(symbol_locations)
            distance(i)=symbol_locations(i)-d_tilde(k);
        end
        [value(k) index(k)]= min(distance);
        
    end
    n=4;        %Modulation Index
       symbol_identified_count=1;
    for k=1:1:length(index)

         %Mapping to bits
        for i=symbol_identified_count:1:symbol_identified_count+3
            demodulatedoutput(i) = bitget((index(k)-1),n);
            n=n-1;
        end
        n=4;
        symbol_identified_count=symbol_identified_count+4;
    end
    c_hat=demodulatedoutput'; %to convert it into a column matrix
    

if switch_graph==1
   
    F = scatterplot(d_tilde,1,0,'r.');                       
    hold on
    scatterplot(symbol_locations,1,0,'g*',F)
    grid
   
end
  

end