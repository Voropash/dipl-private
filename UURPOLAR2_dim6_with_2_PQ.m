function [ output_args ] = UURPOLAR2_dim6_with_2_PQ( s_Q_V, s_0, Q_2_V_3, ConductMatrix, ConductMatrix_s,DIM,P,balanceU )
    %sigma = s_Q(1:DIM+1);
    %Q = s_Q(DIM+2:2*DIM+2);
    %P = [s_Q(2*DIM+3);P];
    
    sigma = [s_0; s_Q_V(1:DIM)];
    Q = [s_Q_V(3); Q_2_V_3(1); s_Q_V(4)];
    P = [s_Q_V(2*DIM+2);P];
    
    U = [balanceU;s_Q_V(5);Q_2_V_3(2)];
    
    mult = zeros(DIM+1,1);
    mult2 = zeros(DIM+1,1);
    for k = 1:1:DIM+1
        for j = 1:1:DIM+1
            if k~=j
                mult(k) = mult(k) + U(j)*(real(ConductMatrix(k,j))*(cos(sigma(k))*cos(sigma(j))+sin(sigma(k))*sin(sigma(j))) - imag(-ConductMatrix(k,j))*(sin(sigma(k))*cos(sigma(j))-cos(sigma(k))*sin(sigma(j))));
                mult2(k) = mult2(k) + U(j)*(-imag(ConductMatrix(k,j))*(cos(sigma(k))*cos(sigma(j))+sin(sigma(k))*sin(sigma(j))) + real(ConductMatrix(k,j))*(sin(sigma(k))*cos(sigma(j))-cos(sigma(k))*sin(sigma(j))));
            end
        end;
    end;
    
    %- diag(real(ConductMatrix_s)).*abs_U.*abs_U
    
   % disp(-P- diag(real(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult);
   % disp(-Q+ diag(imag(ConductMatrix_s)).*abs_U.*abs_U - abs_U.*mult2);
    output_args = double([-P- diag(real(ConductMatrix)).*U.*U - U.*mult;
        -Q+ diag(imag(ConductMatrix)).*U.*U - U.*mult2]);
end

    