%% Матрица Якоби 
J = [diag(G*u-B*v), diag(B*u+G*v);
     -diag(B*u+G*v), diag(G*u-B*v)];
 
J = J + [diag(u), diag(v);
        diag(v), -diag(u)] * [G, -B;
                              B,  G];
                                
%% отбрасываем первый и (DIM+2) столбцы Матрицы Якоби
J_s = [J(2 : DIM+1, 2 : DIM+1)         J(2 : DIM+1, DIM+3 : 2*DIM+2);
        J(DIM+3 : 2*DIM+2, 2 : DIM+1)   J(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];
 

jac = det(J_s);    
   
%% dl/dx = cумма первых строк  Матрицы Якоби
l_x = J(1 : DIM+1, 1 : 2*DIM+2);
l_x = transpose(sum(l_x));
l_x = [l_x(2 : DIM+1); l_x(DIM+3 : 2*DIM+2)];
l_x_dekart = l_x;

%% Решаем систему
l_s = - transpose( transpose(l_x) *((J_s)^(-1)));
 
ppp = [diag([1;1 + l_s(1 : DIM)])         -diag([0;l_s(DIM+1 : 2*DIM)]);
       diag([0;l_s(DIM+1 : 2*DIM)])        diag([1;1 + l_s(1 : DIM)])];
Hessian_FULL = ppp*[ G -B;
                     B G] + transpose([ G -B;
                              B G])*transpose(ppp);
                          
Hessian_FULL_s   = [Hessian_FULL(2 : DIM+1, 2 : DIM+1)         Hessian_FULL(2 : DIM+1, DIM+3 : 2*DIM+2);
                    Hessian_FULL(DIM+3 : 2*DIM+2, 2 : DIM+1)   Hessian_FULL(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];

                
%% Полярная

J_polar = [diag(-U.*sin(sigma))  diag(cos(sigma));
            diag(U.*cos(sigma)) diag(sin(sigma))];

first_slag_of_hess = transpose(J_polar)*Hessian_FULL*J_polar;

e = [zeros(DIM+1,1); ones(DIM+1,1)];
l_x = J(1 : DIM+1, 1 : 2*DIM+2);
l_x = transpose(sum(l_x));

l_x_polar = diag(e+l_x)*J;
l_x_polar = transpose(sum(l_x_polar));

df_du = l_x_polar(1:DIM+1);
df_dv = l_x_polar(DIM+2:2*DIM+2);

K2 = [ diag( df_du.*(-U.*cos(sigma)) + df_dv.*(-U.*sin(sigma)) )   diag( df_du.*(-sin(sigma)) + df_dv.*(cos(sigma)) );
        diag( df_du.*(-sin(sigma)) + df_dv.*(cos(sigma)) )       zeros(DIM+1, DIM+1)  ];
    
Hessian_FULL_polar = first_slag_of_hess + K2;
Hessian_FULL_polar_s   = [Hessian_FULL_polar(2 : DIM+1, 2 : DIM+1)         Hessian_FULL_polar(2 : DIM+1, DIM+3 : 2*DIM+2);
                    Hessian_FULL_polar(DIM+3 : 2*DIM+2, 2 : DIM+1)   Hessian_FULL_polar(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];

min_eig_polar = min(real(roots(poly(Hessian_FULL_polar_s))));
min_eig = min(real(roots(poly(Hessian_FULL_s))));

%l_x = transpose(sum(l_x));
%l_x = [l_x(2 : DIM+1); l_x(DIM+3 : 2*DIM+2)];

%% Старое
                
%levaya_peremennaya1 = transpose(-J_s^(-1))* Hessian_FULL_s * (-J_s^(-1));
%d2l_dp2 = levaya_peremennaya1(1,1);

%uuu = min(real(roots(poly(Hessian_FULL_s))));


%% Значение функции потерь
%F = [diag(u), diag(v);
%    diag(v), -diag(u)] * [ G, -B;
%                           B, G]*[u ; v];
%                      
%   l = 0;
%   for kkkkkkkkk = 1:1:DIM+1
%       l =  l + F(kkkkkkkkk);
%   end