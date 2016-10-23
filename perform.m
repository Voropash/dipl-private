U = -ones(DIM, 1) * 220;
[U,fval,exitflag,output,jacobian] = fsolve(@UUR, U ,optimset('MaxFunEvals',10000,'MaxIter', 10000, 'TolX', 0, 'Algorithm', {'levenberg-marquardt',.01}, 'ScaleProblem', 'Jacobian'), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);
sum_abs_uur( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )

U_previousIteration = U; 
counterOfIterations = 0;
flagNotSeries = false;
I = -conj(S)./conj(U);
while (sum(abs(UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )))>PRECISION)
    U_previousIteration = U;
    %sum(abs(UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )))
    U_new = (ConductMatrix_s)^(-1) * (-ConductMatrix(2:DIM+1,1) * balanceU + I); % resolve linear system    
    I = -conj(S)./conj(U); % vector operation
  
    counterOfIterations = counterOfIterations + 1;
        if (counterOfIterations>2)
            %flagNotSeries = true;
            disp(counterOfIterations);
            break;
        end
end
format longG;
%flagNotSeries
%disp(counterOfIterations)
%UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )

%[U,fval,exitflag,output,jacobian] = fsolve(@UUR, U ,optimset('MaxFunEvals',5000,'MaxIter', 100, 'TolX', 0, 'Algorithm', {'levenberg-marquardt',.1}), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);
%[x,fval,exitflag,output,grad,hessian] = fminunc(@lost_function, ones(DIM,1)*220,optimset('Display', 'off','MaxFunEvals',15000000,'MaxIter',300), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);

u = [balanceU; real(U)];
v = [0; imag(U)];
%output.iterations
if (output.iterations >= 100) 
    flagNotSeries = true;
end

B = -B;
Gessianius;
B = -B;






syms b real
syms g real
syms u_b real
b11 = -b;
g11 = -g;
b22 = -b;
g22  = -g;
g12 = g;
b12 = b;
b21 = b;
g21 = g;
B_syms = [b11,b12; b21, b22];
G_syms = [g11,g12; g21, g22];
u1 = u_b;
v1 = 0;
u2 = - ((b^4*u_b^4 - 4*b^3*q*u_b^2 + 2*b^2*g^2*u_b^4 - 4*b^2*g*p*u_b^2 - 4*b^2*p^2 - 4*b*g^2*q*u_b^2 + 8*b*g*p*q + g^4*u_b^4 - 4*g^3*p*u_b^2 - 4*g^2*q^2)^(1/2) + b^2*u_b^2 + g^2*u_b^2)/(2*(u_b*b^2 + u_b*g^2)); 
v2 = (b*p - g*q)/(u_b*b^2 + u_b*g^2);
%2ое решение = (b*p*1i - g*q*1i)/(u_b*b^2 + u_b*g^2) - (b^2*u_b^2 - (b^4*u_b^4 - 4*b^3*q*u_b^2 + 2*b^2*g^2*u_b^4 - 4*b^2*g*p*u_b^2 - 4*b^2*p^2 - 4*b*g^2*q*u_b^2 + 8*b*g*p*q + g^4*u_b^4 - 4*g^3*p*u_b^2 - 4*g^2*q^2)^(1/2) + g^2*u_b^2)/(2*u_b*b^2 + 2*u_b*g^2);
u_syms = [u1; u2];
v_syms = [v1; v2];

%solve( (g-b*1i)^(-1) * (-(g-b*1i) * u_b - conj(p+q*1i)./conj(us)) - us , us)

J_syms = [diag(G_syms*u_syms-B_syms*v_syms), diag(B_syms*u_syms+G_syms*v_syms);
     -diag(B_syms*u_syms+G_syms*v_syms), diag(G_syms*u_syms-B_syms*v_syms)];

 J_syms = J_syms + [diag(u_syms), diag(v_syms);
        diag(v_syms), -diag(u_syms)] * [G_syms, -B_syms;
                                        B_syms,  G_syms];
                                    
l1_syms = -1/(J_syms(2,2)*J_syms(4,4)-J_syms(2,4)*J_syms(4,2))  * (J_syms(4,4)*(J_syms(1,2)+J_syms(2,2))-J_syms(4,2)*(J_syms(1,4)+J_syms(2,4)));                
l3_syms = -1/(J_syms(2,2)*J_syms(4,4)-J_syms(2,4)*J_syms(4,2))  * (-J_syms(2,4)*(J_syms(1,2)+J_syms(2,2))+J_syms(2,2)*(J_syms(1,4)+J_syms(2,4)));

result = -2*(g*(1+l1_syms)-l3_syms*b);
                                
result = simplify(result)

subsJ = subs(result,[b, g, p, q, u_b],[B_s,G_s,real(S), imag(S),balanceU]);


syms u
syms v
u_syms = [u1; u];
v_syms = [v1; v];

%% ћатрица якоби 
J_syms = [diag(G_syms*u_syms-B_syms*v_syms), diag(B_syms*u_syms+G_syms*v_syms);
     -diag(B_syms*u_syms+G_syms*v_syms), diag(G_syms*u_syms-B_syms*v_syms)];

 J_syms = J_syms + [diag(u_syms), diag(v_syms);
        diag(v_syms), -diag(u_syms)] * [G_syms, -B_syms;
                                        B_syms,  G_syms];
                                
%% отбрасываем первый и (DIM+2) столбцы ћатрицы якоби
J_syms_s = [J_syms(2 : DIM+1, 2 : DIM+1)         J_syms(2 : DIM+1, DIM+3 : 2*DIM+2);
        J_syms(DIM+3 : 2*DIM+2, 2 : DIM+1)   J_syms(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];
 
%% dl/dx = cумма первых строк  ћатрицы якоби
l_syms_x = J_syms(1 : DIM+1, 1 : 2*DIM+2);
l_syms_x = transpose(sum(l_syms_x));
l_syms_x = [l_syms_x(2 : DIM+1); l_syms_x(DIM+3 : 2*DIM+2)];

%% –ешаем систему
l_syms_s = - transpose( transpose(l_syms_x) *((J_syms_s)^(-1)));





%Hessian_FULL_s(1,1) - subsJ(1,1)

