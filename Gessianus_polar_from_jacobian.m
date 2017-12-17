%% ћатрица якоби 
%J = [jacobian(1:6,1:3), [0;0;0;0;0;0], [0;0;0;0;0;0], [0;0;0;0;0;0]];
J = jacobian;                                
%% отбрасываем первый и (DIM+2) столбцы ћатрицы якоби
%J_s = [J(2 : DIM+1, 2 : DIM+1)         J(2 : DIM+1, DIM+3 : 2*DIM+2);
%        J(DIM+3 : 2*DIM+2, 2 : DIM+1)   J(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];
J_s = jacobian(2:3,1:2);   
   
%% dl/dx = cумма первых строк  ћатрицы якоби
l_x = J(1 : DIM+1, 1 : 2*DIM+2);
l_x = transpose(sum(l_x));
l_x_dekart = l_x(1:2);
                    
Hessian_FULL = ([ G -B;
                     B G] + transpose([ G -B;
                                        B G])) / 2;
Hessian_FULL_s   = [Hessian_FULL(2 : DIM+1, 2 : DIM+1)         Hessian_FULL(2 : DIM+1, DIM+3 : 2*DIM+2);
                          Hessian_FULL(DIM+3 : 2*DIM+2, 2 : DIM+1)   Hessian_FULL(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];
min_eig = min(real(roots(poly(Hessian_FULL_s))));
%%


%% ѕол€рна€


J_polar = [diag(-[balanceU; V].*sin(sigma))  diag(cos(sigma));
            diag([balanceU; V].*cos(sigma)) diag(sin(sigma))];
        
first_slag_of_hess = transpose(J_polar)*Hessian_FULL*J_polar;
first_slag_of_hess = [first_slag_of_hess(2:3,2:3), first_slag_of_hess(2:3,5:6);
                      first_slag_of_hess(5:6,2:3), first_slag_of_hess(5:6,5:6)];
%first_slag_of_hess = 0;

U = U(2:3);
sigma = sigma(2:3);

J = [diag(G*u-B*v), diag(B*u+G*v);
     -diag(B*u+G*v), diag(G*u-B*v)];
J = J + [diag(u), diag(v);
        diag(v), -diag(u)] * [G, -B;
                              B,  G];
                          
l_x = J(1 : DIM+1, 1 : 2*DIM+2);
l_x = -transpose(sum(l_x));
df_du = l_x(2:DIM+1);
df_dv = l_x(DIM+3:2*DIM+2);

K2 = [ diag( df_du.*(-U.*cos(sigma)) + df_dv.*(-U.*sin(sigma)) )   diag( df_du.*(-sin(sigma)) + df_dv.*(cos(sigma)) );
        diag( df_du.*(-sin(sigma)) + df_dv.*(cos(sigma)) )       zeros(DIM, DIM)  ];   
%K2 = 0;   
Hessian_FULL_polar = first_slag_of_hess + K2;
%Hessian_FULL_polar_s   = [Hessian_FULL_polar(2 : DIM+1, 2 : DIM+1)         Hessian_FULL_polar(2 : DIM+1, DIM+3 : 2*DIM+2);
%                    Hessian_FULL_polar(DIM+3 : 2*DIM+2, 2 : DIM+1)   Hessian_FULL_polar(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];

min_eig_polar = min(real(roots(poly(Hessian_FULL_polar(1:2,1:2)))));

                