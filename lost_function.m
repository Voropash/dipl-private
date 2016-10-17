function [ output_args ] = lost_function( u,v, G,B )
output_args = sum(real(diag(u+v*1i)*(G-B*1i)*(u-v*1i))); 
end