function [x_k, value] = step_min(params, Func_T_M, define_x, M);
I = eye(length(define_x));
x = sym('x', [1 length(define_x)]);
g = params('grad');
g = g(define_x);
H = params('Hes');
H = H(define_x);
if strcmp(params('step_min_var'), 'first')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Vectors, Diag] = eig(H);
    e = eig(H);
    e_min = max([0, -min(e)]);
    %x_e = C * x_f  => x_f = inv(C) * x_e
    g_new = inv(Vectors) * g;
    %test_data_from_example
    %g_new = [-1; 0];
    %H = [0 0; 0 -1];
    for i = 1:length(g_new)
        if g_new(i) == 0
            g_new(i) = params('new_g_add');
        end
    end
    syms r;
    F = r*r;
    for i = 1 : size(g_new)
       F = F * (e(i) + r*M/2)^2;
    end
    for i = 1 : size(g_new)
        temp = g_new(i)^2;
        for j = 1 : size(g_new)
           if j ~= i
               temp = temp * (e(j) + r*M/2)^2;
           end
        end
        F = F - temp;
    end
    F = expand(F);
    F = sym2poly(F);
    all_roots = roots(F);
    all_ok_roots{1} = 0;
    all_val_ok_roots(1) = 0;
    all_ok_roots_indexes(1) = 0;
    ok_size = 0;
    for i = 1:length(all_roots)
        if (all_roots(i) >= e_min) & isreal(all_roots(i))
           if ok_size == 0
               all_ok_roots{1} = -(H + M*real(all_roots(i))/2*I)^-1*g;
               all_val_ok_roots(1) = Func_T_M(all_ok_roots{1}, g, H, M);
               all_ok_roots_indexes(1) = i;
               ok_size = 1;
           else
               if norm(all_ok_roots{ok_size} - (-(H + M*real(all_roots(i))/2*I)^-1*g)) > 0.01 
                   ok_size = ok_size + 1;
                   all_ok_roots{ok_size} = -(H + M*real(all_roots(i))/2*I)^-1*g;
                   all_val_ok_roots(ok_size) = Func_T_M(all_ok_roots{ok_size}, g, H, M);
                   all_ok_roots_indexes(ok_size) = i;
               end
           end
       end
    end
    [true_value, num] = min(all_val_ok_roots);
    x_k = all_ok_roots{num} + define_x;
    value = true_value;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
elseif strcmp(params('step_min_var'), 'second')
    fprintf(params('file_test'), '--------------------------------------------------------\r\n');
    iter_format = iterformat(3000);
    syms x  r;
    x = inv(H + M*r/2*I)*g;
    F_n = r^2 - norm(x)^2;
    diff_x = -M/2*inv(H + M*r/2*I)*x;
    diff_F = 2*r - 2*sum(x.*diff_x);
    F_n = matlabFunction(F_n);
    diff_F = matlabFunction(diff_F);
    keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'Step', 'file', 'iterformat', 'output_format', 'x*', 'mod'};
    valueSet = { 1,             F_n,      F_n,      diff_F,1e-6,         params('Step_test'),params('file_test'),   iter_format, params('output_format_test'), params('x*_test'), params('mod_test')};
    params_test = containers.Map(keySet,valueSet);
    [result, datax] = newtonbase(params_test);
    datax = cell2mat(datax);
         e = eig(diff_F(result));
         e_min = min(e);
         fprintf(params('file_test'), ' e_min = %10.4f\r\n', e_min);
    %pause(3)
    x_k = -(H + M*real(result)/2*I)^-1*g  + define_x;
    value = Func_T_M(x_k, g, H, M);   
elseif strcmp(params('step_min_var'), 'graph')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Vectors, Diag] = eig(H);
    e = eig(H);
    e_min = max([0, -min(e)]);
    %x_e = C * x_f  => x_f = inv(C) * x_e
    g_new = inv(Vectors) * g;
    %test_data_from_example
    %g_new = [-1; 0];
    %H = [0 0; 0 -1];
    for i = 1:length(g_new)
        if g_new(i) == 0
            g_new(i) = params('new_g_add');
        end
    end
    syms r;
    F = r*r;
    for i = 1 : size(g_new)
       F = F * (e(i) + r*M/2)^2;
    end
    for i = 1 : size(g_new)
        temp = g_new(i)^2;
        for j = 1 : size(g_new)
           if j ~= i
               temp = temp * (e(j) + r*M/2)^2;
           end
        end
        F = F - temp;
    end
    F = expand(F);
    F = sym2poly(F);
    all_roots = roots(F);
    all_ok_roots{1} = -(H + M*real(real(all_roots(1)))/2*I)^-1*g;
    all_val_ok_roots(1) = Func_T_M(all_ok_roots{1}, g, H, M);
    all_ok_roots_indexes(1) = 0;
    ok_size = 0;
    for i = 1:length(all_roots)
       all_roots(i)
        if (all_roots(i) >= e_min) & isreal(all_roots(i))
           if ok_size == 0
               all_ok_roots{1} = -(H + M*real(all_roots(i))/2*I)^-1*g;
               all_val_ok_roots(1) = Func_T_M(all_ok_roots{1}, g, H, M);
               all_ok_roots_indexes(1) = i;
               ok_size = 1;
           else
               if norm(all_ok_roots{ok_size} - (-(H + M*real(all_roots(i))/2*I)^-1*g)) > 0.01 
                   ok_size = ok_size + 1;
                   all_ok_roots{ok_size} = -(H + M*real(all_roots(i))/2*I)^-1*g;
                   all_val_ok_roots(ok_size) = Func_T_M(all_ok_roots{ok_size}, g, H, M);
                   all_ok_roots_indexes(ok_size) = i;
               end
           end
       end
    end
    [true_value, num] = min(all_val_ok_roots);
    %all_ok_roots{num};
    %true_value;
    x_k_1 = all_ok_roots{num};
    x_k = all_ok_roots{num} + define_x;
    value_1 = true_value;
    
    F = r*r;
    for i = 1 : size(g_new)
       F = F * (e(i) + r*M/2)^2;
    end
    for i = 1 : size(g_new)
        temp = g_new(i)^2;
        for j = 1 : size(g_new)
           if j ~= i
               temp = temp * (e(j) + r*M/2)^2;
           end
        end
        F = F - temp;
    end    
    F = matlabFunction(F);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%elseif strcmp(params('step_min_var'), 'second')
    fprintf(params('file_test'), '--------------------------------------------------------\r\n');
    iter_format = iterformat(3000);
    syms x  r;
    x = inv(H + M*r/2*I)*g;
    F_n = r^2 - norm(x)^2;
    diff_x = -M/2*inv(H + M*r/2*I)*x;
    diff_F = 2*r - 2*sum(x.*diff_x);
    F_n = matlabFunction(F_n);
    diff_F = matlabFunction(diff_F);
    keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'Step', 'file', 'iterformat', 'output_format', 'x*', 'mod'};
    valueSet = { 1,             F_n,      F_n,      diff_F,1e-6,         params('Step_test'),params('file_test'),   iter_format, params('output_format_test'), params('x*_test'), params('mod_test')};
    params_test = containers.Map(keySet,valueSet);
    [result, datax] = newtonbase(params_test);
    datax = cell2mat(datax);
         e = eig(diff_F(result));
         e_min = min(e);
         fprintf(params('file_test'), ' e_min = %10.4f\r\n', e_min);
    %pause(3)
    x_k = -(H + M*real(result)/2*I)^-1*g;
    value = Func_T_M(x_k+ define_x, g, H, M);   

    a = min([real(all_roots') datax]);
    b = max([real(all_roots') datax]);
    X = a:0.1:b;
    Y = F(X);
    figure;
    plot(X, Y);
    hold on;
    plot(datax, F(datax),'Color', 'red');
    for i = 1: length(all_roots)
       if imag(all_roots(i)) == 0
            if all_ok_roots_indexes(num) == i 
                line(all_roots(i), F(all_roots(i)),'Color', 'green', 'Marker', '.', 'MarkerSize', 30) ;
            else
                line(all_roots(i), F(all_roots(i)),'Color', 'green', 'Marker', '.', 'MarkerSize', 10) ;
            end
       end
    end
for i = 1:length(datax)
    if imag(datax(i)) == 0 
        line(datax(i), F(datax(i)),'Color', 'black', 'Marker', '.', 'MarkerSize', 10);
    end;
end
plot([a:1:b], zeros(1, length([a:1:b])));

iter = 1;
for i = a:0.1:b
      temp = -(H + M*i/2*I)^-1*g ;
      xd(iter) = temp(1);
      yd(iter) = temp(2);
      zd(iter) = F(i);
      iter = iter + 1;
end
xmin = min(xd);
xmax = max(xd);
ymin = min(yd);
ymax = max(yd);
X0 = xmin:(xmax-xmin)/50:xmax; 
Y0=ymin:(xmax-xmin)/50:ymax;
[X, Y] = meshgrid(X0, Y0);
s = size(X); Z=zeros(s);
for i = 1:s(1)
    for j = 1:s(2)
        Z(i, j) = Func_T_M([X(i, j) Y(i, j)]', g, H, M);
    end
end
grid off;
figure;
C = del2(Z);
mesh(X, Y, Z, C,'FaceLighting','gouraud','LineWidth',0.3);
hold on;
for i = 1:iter-1
    line(xd(i), yd(i), zd(i), 'Color', 'black', 'Marker', '.', 'MarkerSize', 10);
end
hold on;
plot3(xd, yd, zd, 'Color', 'blue');
hold on;
for i = 1:length(datax)
      temp = -(H + M*datax(i)/2*I)^-1*g ;
      xdne(i) = temp(1);
      ydne(i) = temp(2);
      zdne(i) = Func_T_M(temp, g, H, M);
      line(xdne(i), ydne(i), zdne(i), 'Color', 'red', 'Marker', '.', 'MarkerSize', 10);
end
line(xdne(i), ydne(i), zdne(i), 'Color', 'red', 'Marker', '.', 'MarkerSize', 40);
line(x_k_1(1), x_k_1(2), Func_T_M(x_k_1, g, H, M),'Color', 'green', 'Marker', '.', 'MarkerSize', 35) ;
hold on;
plot3(xdne, ydne, zdne, 'Color', 'red');
fprintf(params('difference_file'), '%10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\r\n', norm(x_k - x_k_1), Func_T_M(x_k, g, H, M) - Func_T_M(x_k_1, g, H, M), x_k, x_k_1)
x_k = -(H + M*real(result)/2*I)^-1*g  + define_x;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pause(10)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% syms x;
% F = x - norm(inv(H + M*x/2*I)*g);
% F = matlabFunction(F);
% vec = 0;
% options = optimoptions('fsolve', 'Algorithm', 'levenberg-marquardt', 'Display','iter');
% all_res = 0;
% size = 0;
% for i = 100:-1:-100
%     if det(H + M*i/2*I) ~= 0
%        [res, fval, exitflag, output] = fsolve(F, i, options);
%        if exitflag == 1
%            if size == 0
%                all_res = res;
%                size = 1;
%            else
%               if norm(all_res(length(all_res)) - res) > 0.01 
%                   all_res(length(all_res)+1) = res;
%               end
%            end
%        end
%    end
% end
% res = all_res(1);
% all_res
% res, fval, exitflag, output
% res = -(H + M*res/2*I)^-1*g;
% %y=4:0.01:6;
% %plot(y, F(y));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F_diff = g + H*x' + 1/2*M*norm(x')*x';
% F_diff = matlabFunction(F_diff, 'vars', {x});
% all_resu{1} = 0;
% size_res = 0;
% for i = 100:-1:-100
%        [result, fval, exitflag, output] = fsolve(F_diff, [i i]);
%        result
%        if exitflag == 1
%            if size_res == 0
%                all_resu{1} = result;
%                size_res = 1;
%            else
%                if norm(all_resu{length(all_resu)} - result) > 0.01
%                   all_resu{length(all_resu)+1} = result;
%               end
%            end
%        end
% end
% result = all_resu{1};
% all_val = 0;
% for i = 1:length(all_resu)
%     all_resu{i};
%     all_val(i) = Func(all_resu{i});
% end
% [true_value, num] = min(all_val);
% all_resu{num}
% true_value
% %F(result)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%