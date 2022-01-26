clc
clear all;
close all;
% Transmitter model starts here
%% Analog Source %%
par_no=1000;
switch_reset=1;
switch_graph=0;
a = analog_source(par_no,switch_reset,switch_graph) ;

%% AD Conversion %%
par_w=2;
par_q=8;
switch_graph=0;
u = ad_conversion(a,par_w,par_q,switch_graph);

%% Source Coding %%
par_scblklen=100;
switch_graph=0;
switch_off=0;
[b, c_tree,l_x] = source_coding(u,par_scblklen,switch_off,switch_graph);

%% Tx FIFO buffer %%

par_ccblklen=800;
switch_reset=1;
            %floor(sum(l_x)/par_ccblklen);

if(mod(length(b),par_ccblklen)>0)
zp=par_ccblklen-mod(length(b),par_ccblklen);
b=[b;zeros(zp,1)];            %Append zp no of zeros to 'b'
par_fifolen=length(b);
else
par_fifolen=length(b);
end
buf_count=par_fifolen/par_ccblklen;
SNR_Start_value =1;
SNR_Stop_value  =10;
SNR_Step_value=2;
BitErr =[];
MSErr = [];

for par_SNRdB=SNR_Start_value:SNR_Step_value:SNR_Stop_value
switch_reset =1; %Empties buffer before filling

for i=1:buf_count

[b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,switch_reset);
%switch_reset=0;

%% channel coding %%

%par_H=hammgen(3);
par_H=[1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
switch_off=0;
c = channel_coding(b_buf,par_H,switch_off);


%% Modulation %%

switch_mod=0;
switch_graph=0;
d  = modulation(c, switch_mod, switch_graph);

%% Transmission Filter %%

par_tx_w=8;
switch_graph=0;
s  = tx_filter(d,par_tx_w,switch_graph);

%% Tx Hardware %%

par_txthresh=1;
switch_graph=0;
x = tx_hardware(s,par_txthresh,switch_graph);

%% channel %%
switch_graph=0;
%par_SNRdB=10;
y=channel(x,par_SNRdB,switch_graph);

%Receiver Model Starts here
%% Rx Hardware  %%
par_rxthresh=1;
switch_graph=0;
s_tilde = rx_hardware(y,par_rxthresh,switch_graph);

%% Rx Filter %%
par_rx_w=par_tx_w;
switch_graph=0;
d_tilde=rx_filter(s_tilde,par_rx_w,switch_graph);

%% Demodulation %%
switch_mod = 0;
switch_graph=0;
c_hat=demodulation(d_tilde,switch_mod,switch_graph);

%% Channel decoding %%
%par_H      = hammgen(3);
par_H=[1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
switch_off = 0;
b_hat=channel_decoding(c_hat,par_H,switch_off);

%% Rx FIFO buffer %%
par_sdblklen=100;
par_fifolen=[];
switch_reset=0;
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset);

end

%% Source decoding %%
par_scblklen=length(b);
switch_off=0;
u_hat = source_decoding(b_hat_buf,c_tree,switch_off);

%% DA Conversion %%
switch_graph=0;
a_tilde=da_conversion(u_hat,par_w,par_q,switch_graph);

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