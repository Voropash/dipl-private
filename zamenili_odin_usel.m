%% All dots
from_x = -1.7;
to_x = 0.6;
step_x = 0.005;
from_y = -1.7;
to_y = 0.6;
step_y = 0.005;
%% Q_2 (1 nonbalance node)
Q_2 = 0.13;


abc = [];
ord = [];
ii = [];
ii_axes = [];
jj = [];
boolean_matrix = [];
jj_axes = [];
ord_polar = [];
ord_matrix = [];
ord_polar_matrix = [];

for i = from_x:step_x:to_x
    ii_axes = [ii_axes; i];
end
for j = from_y:step_y:to_y
    jj_axes = [jj_axes; j];
end

i_count = 0;
for i = from_x:step_x:to_x
    i_count = i_count + 1;
    j_count = 0;
    disp(i);
    datetime('now')
    for j = from_y:step_y:to_y
        j_count = j_count + 1;
        P = [i; j];
        s_Q_V = [
          0;0; % sigma start
          0;0; % Q 
          0; % V
          0 % P
        ];
        Q_2_V_3 = [Q_2; V(2)];
        [s_Q_V,fval,exitflag,output,jacobian] = fsolve(@UURPOLAR2_dim6_with_2_PQ, s_Q_V ,optimset('Display', 'none', 'Algorithm',  {'levenberg-marquardt',.05}), 0, Q_2_V_3, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
        if exitflag == 1
            U = [balanceU; V];
            sigma = [0; s_Q_V(1:DIM)];

            u = [balanceU; V].*cos(sigma);
            v = [balanceU; V].*sin(sigma);

            Gessianus_polar_from_jacobian;

            ii = [ii; i];
            jj = [jj; j];
            ord_polar_matrix(i_count, j_count) =  -s_Q_V(2*DIM+2)-P(1)-P(2); % det(jacobian); % min_eig_polar;
            boolean_matrix(i_count, j_count) = 10;
        else 
            ord_polar_matrix(i_count, j_count) = 0;            
            boolean_matrix(i_count, j_count) = 0;
        end
    end
end

tr_ord_polar_matrix = max(-2, ord_polar_matrix);
tr_ord_polar_matrix = min(4, tr_ord_polar_matrix);

%surf(jj_axes,ii_axes,tr_ord_polar_matrix);
surf(ii_axes,jj_axes,boolean_matrix)