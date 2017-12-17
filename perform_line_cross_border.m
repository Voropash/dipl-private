abc = [];
ii = [];
ii_axes = [];
jj = [];
dets = [];
boolean_matrix = [];
jj_axes = [];
ord_polar = [];
ord = [];
ord_matrix = [];
ord_polar_matrix = [];
l_s_vector = [];
s_Q_vector = [];
fval_vector = [];

i_count = 0;
for i = 250:0.091:270
    P = [-0.3-0.0001*i; -0.00-0.0001*i];
    s_Q = zeros(2*DIM, 1);
    [s_Q,fval,exitflag,output,jacobian] = fsolve(@UURPOLAR2, s_Q ,optimset('Display', 'none'), V, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
    
    if exitflag == 1
        %disp(s_Q)
        U = [balanceU; V];
        
        %sigma = [0; s_Q(DIM+1: DIM*2)];
        sigma = [0; s_Q(1:DIM)];
        
        u = [balanceU; V].*cos(sigma);
        v = [balanceU; V].*sin(sigma);

        Gessianus_polar;
        
        dets = [dets; det(jacobian)];
        vpa(det(jacobian),7)

        ord_polar = [ord_polar; min_eig_polar];
        ord = [ord; min_eig];
        l_s_vector = [l_s_vector, l_s];
        s_Q_vector = [s_Q_vector, s_Q];
        fval_vector = [fval_vector, fval];
        ii = [ii; i];
    end
end

%tr_ord_polar = max(-150, ord_polar)
%tr_ord_polar = min(20, tr_ord_polar)

subplot(2,2,1), 
scatter(ii,s_Q_vector(1, :),'.')
hold on
scatter(ii,s_Q_vector(2, :),'.')
scatter(ii,s_Q_vector(3, :),'.')
scatter(ii,s_Q_vector(4, :),'.')
hold off

title('Решение уравнений баланса')

subplot(2,2,2), 
scatter(ii,fval_vector(1, :),'.')
hold on
scatter(ii,fval_vector(2, :),'.')
scatter(ii,fval_vector(3, :),'.')
scatter(ii,fval_vector(4, :),'.')
hold off
title('Значение уравнений баланса в точке решения')

subplot(2,2,3), 
scatter(ii,l_s_vector(1, :),'.')
hold on
scatter(ii,l_s_vector(2, :),'.')
scatter(ii,l_s_vector(3, :),'.')
scatter(ii,l_s_vector(4, :),'.')
hold off
title('Производные функции потерь по нагрузкам')

subplot(2,2,4), 
scatter(ii,dets,'.')
title('Определитель Якоби')

%subplot(2,2,4), 
%scatter(ii,ord,'.')
%ylim([0.16 0.19]);
%title('Минимальное собственное значение матрицы H')
