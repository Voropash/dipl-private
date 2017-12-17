function [ output_args ] = UURPOLAR2( s_Q, abs_U, ConductMatrix, ConductMatrix_s,DIM,P,balanceU )
    sigma_non_balance = s_Q(1:DIM);
    Q = s_Q(DIM+1:2*DIM);
    
    U = [balanceU;abs_U];
    sigma = [0; sigma_non_balance];
    mult = zeros(DIM,1);
    mult2 = zeros(DIM,1);
    for k = 2:1:DIM+1
        for j = 1:1:DIM+1
            if k~=j
                mult(k-1) = mult(k-1) + U(j)*(real(ConductMatrix(k,j))*(cos(sigma(k))*cos(sigma(j))+sin(sigma(k))*sin(sigma(j))) - imag(-ConductMatrix(k,j))*(sin(sigma(k))*cos(sigma(j))-cos(sigma(k))*sin(sigma(j))));
                mult2(k-1) = mult2(k-1) + U(j)*(-imag(ConductMatrix(k,j))*(cos(sigma(k))*cos(sigma(j))+sin(sigma(k))*sin(sigma(j))) + real(ConductMatrix(k,j))*(sin(sigma(k))*cos(sigma(j))-cos(sigma(k))*sin(sigma(j))));
            end
        end;
    end;
    
    %- diag(real(ConductMatrix_s)).*abs_U.*abs_U
    
   % disp(-P- diag(real(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult);
   % disp(-Q+ diag(imag(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult2);
    output_args = double([-P- diag(real(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult;
        -Q+ diag(imag(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult2]);
end

    