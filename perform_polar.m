%% All dots
from = -1.7;
to = 0.6;
step = 0.05;
%% Center
from = -0.55;
to = 0.55;
step = 0.05;

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

for i = from:step:to
    ii_axes = [ii_axes; i];
end
for j = from:step:to
    jj_axes = [jj_axes; j];
end

i_count = 0;
for i = from:step:to
    i_count = i_count + 1;
    j_count = 0;
    disp(i);
    datetime('now')
    for j = from:step:to
        j_count = j_count + 1;
        P = [i; j];
        s_Q = ones(3*DIM+1, 1);
        [s_Q,fval,exitflag,output,jacobian] = fsolve(@UURPOLAR2_dim6, s_Q ,optimset('Display', 'none', 'Algorithm', 'Levenberg-Marquardt'), V, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
        if exitflag == 1
            U = [balanceU; V];
            sigma = [0; s_Q(1:DIM)];

            u = [balanceU; V].*cos(sigma);
            v = [balanceU; V].*sin(sigma);

            Gessianus_polar_from_jacobian;

            ii = [ii; i];
            jj = [jj; j];
            ord_matrix(i_count, j_count) = min_eig;
            ord_polar_matrix(i_count, j_count) = min_eig_polar;
            boolean_matrix(i_count, j_count) = 10;
            %disp(P);
        else 
           % disp 'error';
            ord_matrix(i_count, j_count) = 0;    
            ord_polar_matrix(i_count, j_count) = 0;            
            boolean_matrix(i_count, j_count) = 0;
        end
    end
end

%subplot(2,1,1), 
%plot(abc, ord_polar)
%title('polar')

%subplot(2,1,2), 
%plot(abc, ord)
%title('dekart')

tr_ord_polar_matrix = max(-2, ord_polar_matrix);
tr_ord_polar_matrix = min(4, tr_ord_polar_matrix);
tr_ord_matrix = max(-2, ord_matrix);
tr_ord_matrix = min(4, tr_ord_matrix);

surf(jj_axes,ii_axes,tr_ord_polar_matrix);
%contour(ii_axes,jj_axes,tr_ord_matrix)