function [x_k, value] = step_min_test(g, H, Func_T_M, define_x, M, t_id)

    I = eye(length(define_x));
    fprintf(t_id, '--------------------------------------------------------\r\n');
    outformat = zeros(10000, 1);
    for i = 1:20
       outformat(i) = 1;
    end;
    for i = 2:5
       outformat(i*10) = 1;
    end;
    for i = 1:20
       outformat(i*50) = 1;
    end;
    for i = 1100:100:10000
       outformat(i) = 1;
    end;
syms x  r;
x = inv(H + M*r/2*I)*g;
F = r^2 - norm(x)^2;
diff_x = -M/2*inv(H + M*r/2*I)*x;
diff_F = 2*r - 2*sum(x.*diff_x);
F = matlabFunction(F);
diff_F = matlabFunction(diff_F);
%result = newtonbase(1, F, F, diff_F, 0.0000001, 0.01)
%y=:0.01:6;
% %plot(y, F(y));
keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'Step', 'file', 'iterformat', 'output_format', 'x*', 'step_armiho', 'lambda_0', 'betta', 'sigma'};
valueSet = { 1,             F     , F,      diff_F,1e-6,         0.01,   t_id,   outformat,   'first',         'no', 'false'       ,  1.2,       0.6,     0.6   };
params = containers.Map(keySet,valueSet);
result = newtonbase(params);
     e = eig(diff_F(result))
     e_min = min(e)
     fprintf(t_id, ' e_min = %10.4f\r\n', e_min);
%pause(3)
x_k = -(H + M*real(result)/2*I)^-1*g;
value = Func_T_M(x_k, g, H, M);
