clc
clear;
close all;
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

%% Source Coding %%
par_scblklen=100;
switch_graph=1;
switch_off=0;
[b, c_tree,l_x] = source_coding(u,par_scblklen,switch_off,switch_graph);

%% Tx FIFO buffer %%

par_ccblklen=1200;

if(mod(length(b),par_ccblklen)>0);
zp=par_ccblklen-mod(length(b),par_ccblklen);
b=[b;zeros(zp,1)];                                 %Adding zeros to remaining length
par_fifolen=length(b);
else
par_fifolen=length(b);
end

buf_count=par_fifolen/par_ccblklen;

SNR_Start_value =1;
SNR_Stop_value  =20;
SNR_Step_value= 1;
BitErr =[];
MSErr = [];

for par_SNRdB=SNR_Start_value:SNR_Step_value:SNR_Stop_value

switch_reset =1; %Empties buffer before filling
for i=1:buf_count

[b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,switch_reset);

%% channel coding %%
par_H=hammgen(3);
switch_off=0;
c = channel_coding(b_buf,par_H,switch_off);

%% Modulation %%

switch_mod=0;
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
d  = modulation(c, switch_mod, switch_graph);

%% Transmission Filter %%

par_tx_w=8;
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
s  = tx_filter(d,par_tx_w,switch_graph);

%% Tx Hardware %%

par_txthresh=1;
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
x = tx_hardware(s,par_txthresh,switch_graph);

%% channel %%
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
%par_SNRdB=20;
y=channel(x,par_SNRdB,switch_graph);

%Receiver Model 
%% Rx Hardware  %%
par_rxthresh=1;
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
s_tilde = rx_hardware(y,par_rxthresh,switch_graph);

%% Rx Filter %%
par_rx_w=par_tx_w;
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
d_tilde=rx_filter(d,s,s_tilde,par_rx_w,switch_graph);

%% Demodulation %%
switch_mod = 0;
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
c_hat=demodulation(d_tilde,switch_mod,switch_graph);

%% Channel decoding %%
par_H = hammgen(3);
switch_off = 0;
b_hat=channel_decoding(c_hat,par_H,switch_off);

%% Rx FIFO buffer %%
par_sdblklen=length(b);
par_fifolen=[];
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset,switch_graph);
switch_reset=0;

end

%% Source decoding %%
par_scblklen=length(b);
switch_off=0;
u_hat = source_decoding(b_hat_buf,c_tree,switch_off,par_q,zp,l_x);

%% DA Conversion %%
if par_SNRdB == SNR_Stop_value
switch_graph=1;
else
    switch_graph=0;
end
%switch_graph=1;
a_tilde=da_conversion(u_hat,par_q,par_w,switch_graph);

%% Analog Sink %%
length(a_tilde)
[MSE,BER]=analog_sink(a,a_tilde(1:length(a)),b,b_hat_buf(1:length(b)));
BitErr =[BitErr BER];
MSErr = [MSErr MSE];

end
figure('name','BER VS. SNR');
SNR=SNR_Start_value:SNR_Step_value:SNR_Stop_value;
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

