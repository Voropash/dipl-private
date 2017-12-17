function [ output_args ] = UURPOLAR( U_abs_sygm ,ConductMatrix, ConductMatrix_s,DIM,S,balanceU )
    abs_U = U_abs_sygm(1:DIM);
    sigma_non_balance = U_abs_sygm(DIM+1:2*DIM);
    
    U = [balanceU;abs_U];
    sigma = [0; sigma_non_balance];
    mult = sym(zeros(DIM,1));
    mult2 = sym(zeros(DIM,1));
    for k = 2:1:DIM+1
        for j = 1:1:DIM+1
            if k~=j
                mult(k-1) = mult(k-1) + U(j)*(real(ConductMatrix(k,j))*(cos(sigma(k))*cos(sigma(j))+sin(sigma(k))*sin(sigma(j))) - imag(-ConductMatrix(k,j))*(sin(sigma(k))*cos(sigma(j))-cos(sigma(k))*sin(sigma(j))));
                mult2(k-1) = mult2(k-1) + U(j)*(-imag(ConductMatrix(k,j))*(cos(sigma(k))*cos(sigma(j))+sin(sigma(k))*sin(sigma(j))) + real(ConductMatrix(k,j))*(sin(sigma(k))*cos(sigma(j))-cos(sigma(k))*sin(sigma(j))));
            end
        end;
    end;
    
    - diag(real(ConductMatrix_s)).*abs_U.*abs_U
    
    %disp(-real(S)- diag(real(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult);
    %disp(-imag(S)+ diag(imag(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult2);
    output_args = double([-real(S)- diag(real(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult;
        -imag(S)+ diag(imag(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult2]);
end

    