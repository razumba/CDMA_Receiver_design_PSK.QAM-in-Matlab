function ad_conversion
%Ad_conversion achieves signal downsampling and quantization of the input
%signal
%
%   [u] = ad_conversion(a,par_w,par_q,switch_graph)
%
%   The input signal 'a' will be firstly downsampled by factor 'par_w' and
%   then quantized with 'par_q' bits, which means that the amplitude of each
%   input oversampled signal will be represented by a par_q bits row
%   vector, e.g. par_w = 2, par_q = 8. What should be noticed is that the
%   length of signal after downsampling should be larger or at least equal 
%   to the block size for the source_coding!
%
%   switch_graph here is used to control the switchable figure for the
%   quantized analog signal and quantization error.
%
%   On:  switch_graph = 1;
%   Off: switch_graph = 0;



% par_w = 2;
% par_q = 8;
% switch_graph=0; 



end

