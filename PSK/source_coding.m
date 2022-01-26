function  source_coding
%SOURCE_CODING excutes the huffman encoding for the input signal 
%    
%   [b, code_tree, len_idx] = source_coding(u,par_scblklen,switch_off,switch_graph)
%
%   source_coding encodes the input signal 'u' using Huffman coding if 
%
%   On:  switch_off = 0; indicates using the Huffman source coding  
%   Off: switch_off = 1; indicates no source coding
%   
%   If the Huffman coding is switched off, the input signal will be
%   delivered directly. If not, the input message 'u' will be firstly recovered
%   to the respective signal (symbols) before quantization and then encoded by 
%   huffman coding blcok by block w.r.t block size of 'par_scblklen', e.g. par_scblklen = 100.
%
%   The parameter 'switch_graph' is used to control the display of a histogram of huffman encoding over
%   one block:
%   On:  switch_graph = 1;
%   Off: switch_graph = 0;
%
%   'code_tree': the huffman encoding code tree for every block
%   'len_idx': record the block sizes of each block (either using the length 
%   index of coded block or using 'b' for source decoding )



% par_blklen = 10;
% switch_off = 0;
% switch_flag = 1;

end
         
% end

