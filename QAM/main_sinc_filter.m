clc
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Transmitter model starts here%%%%%%%%%%%%%%

%% Analog Source %%

par_no=1000;
switch_reset=1;
switch_graph=1;
a = analog_source(par_no,switch_reset,switch_graph) ;

 %% AD Conversion %%

 par_w=2;
 par_q=8;
 switch_graph=1;
 u = ad_conversion(a,par_w,par_q,switch_graph);
 
%%% Source Coding %%
 
par_scblklen=100;
 switch_graph=1;
 switch_off=0;
 [b, c_tree,l_x] = source_coding(u,par_scblklen,switch_off,switch_graph);
 
 %% Tx FIFO buffer %%
 
 par_ccblklen=1200;

 if(mod(length(b),par_ccblklen)>0)
 zp=par_ccblklen-mod(length(b),par_ccblklen);
 b=[b;zeros(zp,1)];            %Append zp no of zeros to 'b'
 par_fifolen=length(b);
 else
 par_fifolen=length(b);
 end
 buf_count=par_fifolen/par_ccblklen;
 SNR_Start_value =1;
SNR_Stop_Value  =20;
SNR_Step_value=1;
BitErr =[];
MSErr = [];

for par_SNRdB=SNR_Start_value:SNR_Step_value:SNR_Stop_Value
 switch_reset =1; %Empties buffer before filling
 for i=1:buf_count
 
 [b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,switch_reset);

%% channel coding %%

par_H=[1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
switch_off=0;
c = channel_coding(b_buf,par_H,switch_off);


%% Modulation %%

switch_mod=1;
if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
d  = modulation(c, switch_mod, switch_graph);

%% Transmission Filter %%

par_tx_w=8;
if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
s  = tx_filter(d,par_tx_w,switch_graph);

%% Tx Hardware %%

par_txthresh=1;

if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
x = tx_hardware(s,par_txthresh,switch_graph);


%% channel %%

if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
%par_SNRdB=20;
y=channel(x,par_SNRdB,switch_graph);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Receiver Model Starts here%%%%%%%%%%%%%

%% Rx Hardware  %%

par_rxthresh=1;
if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end

s_tilde = rx_hardware(y,par_rxthresh,switch_graph);

%% Rx Filter %%

par_rx_w=par_tx_w;
if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
d_tilde=rx_filter_sinc(s_tilde,par_rx_w,switch_graph);

%% Demodulation %%

switch_mod = 1;
if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
c_hat=demodulation(d_tilde,switch_mod,switch_graph);

%% Channel decoding %%

par_H=[1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
switch_off = 0;
[b_hat,ctr]=channel_decoding(c_hat,par_H,switch_off,par_SNRdB,i);

%% Rx FIFO buffer %%

par_sdblklen=length(b);
par_fifolen=[];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset);
switch_reset=0;
 end

% Source decoding %%

par_sdblklen=length(b);
switch_off=0;
u_hat = source_decoding(l_x,b_hat_buf,c_tree,switch_off);

 
%% DA Conversion %%

if par_SNRdB == SNR_Stop_Value
switch_graph=1;
else
  switch_graph=0;  
end
a_tilde=da_conversion(u_hat,par_w,par_q,switch_graph);
 
%% Analog Sink %%
[MSE,BER]=analog_sink(a,a_tilde(1:length(a)),b(1:sum(l_x)),b_hat_buf(1:sum(l_x)));

if par_SNRdB == SNR_Stop_Value

    display(par_SNRdB,'SNR Value');
    Rx_sam = length(a_tilde)
    MSE
    BER
    figure('name','Exemplary code word indicating corrected errors for diff SNRs');
    subplot(2,2,1)
    stem((1:1:7),ctr(10,:));
    xlabel('Bit location');
    ylabel('No of corrections');
    legend('SNR=5');
    subplot(2,2,2)
    stem((1:1:7),ctr(20,:));
    xlabel('Bit location');
    ylabel('No of corrections');
    legend('SNR=10');
    subplot(2,2,3)
    stem((1:1:7),ctr(30,:));
    xlabel('Bit location');
    ylabel('No of corrections');
    legend('SNR=15');
    subplot(2,2,4)
    stem((1:1:7),ctr(40,:));
    xlabel('Bit location');
    ylabel('No of corrections');
    legend('SNR=20');
end


BitErr =[BitErr BER];
MSErr = [MSErr MSE];

end

figure('name','BER VS. SNR');
SNR=SNR_Start_value:SNR_Step_value:SNR_Stop_Value;
semilogy(SNR, BitErr,'k*-','linewidth',2);
hold on
grid on;
xlabel('SNR(DB) -->');
ylabel('BER -->');
figure('name','MSE VS. SNR');
semilogy(SNR, MSErr,'k*-','linewidth',2);
hold on
grid on;
xlabel('SNR(DB) -->');
ylabel('MSE -->');