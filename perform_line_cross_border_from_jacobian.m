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
loss = [];
min_eig_polar_saved = 0;


% deep cut
start_y = -1.35;
end_y = -1.2;
start_x = -0.25;
end_x = 0.5;
steps = 4500;
%% end cut
start_x = -1.4;
end_x = -1.35;
start_y = -0.75;
end_y = -0.6;
steps = 150;
%% center cross cut
start_x = 0.21;
end_x = -0.2;
start_y = -0.21;
end_y = 0.2;
steps = 150;
%% middle cut
start_x = -1;
end_x = -1;
start_y = 0.25;
end_y = 0.55;
steps = 150;
%% middle cut
start_x = -0.5;
end_x = -0.5;
start_y = 0;
end_y = 0.5;
steps = 150;

i_count = 0;
for i = 0:1:steps
    %% end of area
    %if i<(steps * 0.50)
    %    continue
    %end
    %% begin of area
    %if i>(steps * 0.60)
    %    continue
    %end
    
    i
    P = [start_x + (end_x-start_x)*i/steps; start_y + (end_y-start_y)*i/steps];
    s_Q = [
        0;0; % sigma start
        0;0;0; % Q 
        1 % P
        ];
    [s_Q,fval,exitflag,output,jacobian] = fsolve(@UURPOLAR2_dim6, s_Q ,optimset('Display', 'none', 'Algorithm',  {'levenberg-marquardt',.005}), 0, V, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
    if exitflag == 1
        U = [balanceU; V];
        
        sigma = [0;s_Q(1:DIM)];
        
        u = [balanceU; V].*cos(sigma);
        v = [balanceU; V].*sin(sigma);
        
        Gessianus_polar_from_jacobian;

        dets = [dets; det(jacobian)];
        
        loss = [loss; -s_Q(2*DIM+2)-P(1)-P(2)];
        l_s_vector = [l_s_vector, l_x_dekart];
        %l_s_vector = [l_s_vector, ([Hessian_FULL_polar(1,1);Hessian_FULL_polar(2,2)]-min_eig_polar_saved)/ ((sqrt((end_x - start_x)*(end_x - start_x) + (end_x - start_x)*(end_x - start_x))) / steps)];
        min_eig_polar_saved = [Hessian_FULL_polar(1,1);Hessian_FULL_polar(2,2)];
        fval_vector = [fval_vector, fval];
        ii = [ii; i];
      
        ord = [ord; min_eig_polar];
    end
end

subplot(2,2,1), 
scatter(ii,fval_vector(1, :),'.')
hold on
scatter(ii,fval_vector(2, :),'.')
scatter(ii,fval_vector(3, :),'.')
scatter(ii,fval_vector(4, :),'.')
ylim([-10;10]);
hold off
title('Значение уравнений баланса в точке решения')

subplot(2,2,1), 
scatter(ii,loss,'.')
title('Потери')

subplot(2,2,2), 
scatter(ii(2:size(ii)),l_s_vector(1, 2:size(ii)),'.')
hold on
scatter(ii(2:size(ii)),l_s_vector(2, 2:size(ii)),'.')
hold off
title('Производные функции потерь по нагрузкам')

subplot(2,2,3), 
scatter(ii,dets,'.')
%ylim([-1;1]);
title('Определитель Якоби')

subplot(2,2,4), 
scatter(ii,ord,'.')
%ylim([-1;1]);
title('Гесс')
