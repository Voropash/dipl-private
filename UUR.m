function [ output_args ] = UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )
output_args = conj(S)./conj(U) + balanceU* ConductMatrix(2:DIM+1,1) + ConductMatrix_s * U;
end

