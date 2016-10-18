function [ output_args ] = UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )
output_args = (ConductMatrix_s)^(-1) * (-ConductMatrix(2:DIM+1,1) * balanceU - conj(S)./conj(U)) - U;
%conj(S)./conj(U) + balanceU* ConductMatrix(2:DIM+1,1) + ConductMatrix_s * U;
end

