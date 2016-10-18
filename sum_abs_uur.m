function [ output_args ] = sum_abs_uur( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )
output_args = sum(abs(UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )));
end

