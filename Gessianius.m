%% ћатрица якоби 
J = [diag(G*u-B*v), diag(B*u+G*v);
     -diag(B*u+G*v), diag(G*u-B*v)];

 J = J + [diag(u), diag(v);
        diag(v), -diag(u)] * [G, -B;
                              B,  G];
                                
%% отбрасываем первый и (DIM+2) столбцы ћатрицы якоби
J_s = [J(2 : DIM+1, 2 : DIM+1)         J(2 : DIM+1, DIM+3 : 2*DIM+2);
        J(DIM+3 : 2*DIM+2, 2 : DIM+1)   J(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];
 
%% dl/dx = cумма первых строк  ћатрицы якоби
l_x = J(1 : DIM+1, 1 : 2*DIM+2);
l_x = transpose(sum(l_x));
l_x = [l_x(2 : DIM+1); l_x(DIM+3 : 2*DIM+2)];

%% –ешаем систему
l_s = - transpose( transpose(l_x) *((J_s)^(-1)));
 
ppp = [diag([1;1 + l_s(1 : DIM)])         -diag([0;l_s(DIM+1 : 2*DIM)]);
       diag([0;l_s(DIM+1 : 2*DIM)])        diag([1;1 + l_s(1 : DIM)])];
Hessian_FULL = ppp*[ G -B;
                     B G] + transpose([ G -B;
                              B G])*transpose(ppp);
                          
Hessian_FULL_s   = [Hessian_FULL(2 : DIM+1, 2 : DIM+1)         Hessian_FULL(2 : DIM+1, DIM+3 : 2*DIM+2);
                    Hessian_FULL(DIM+3 : 2*DIM+2, 2 : DIM+1)   Hessian_FULL(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];

levaya_peremennaya1 = transpose(-J_s^(-1))* Hessian_FULL_s * (-J_s^(-1));
d2l_dp2 = levaya_peremennaya1(1,1);

uuu = min(real(roots(poly(Hessian_FULL_s))));


%% «начение функции потерь
F = [diag(u), diag(v);
    diag(v), -diag(u)] * [ G, -B;
                           B, G]*[u ; v];
                       

F = -[diag(v), diag(u);
    -diag(u), diag(v)]  * [ G, B; 
                            B, -G]*[u ; v];
                        
   l = 0;
   for kkkkkkkkk = 1:1:DIM+1
       l =  l + F(kkkkkkkkk);
   end    
   