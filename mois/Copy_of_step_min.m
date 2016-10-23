function [x_k, value, x_k_test, value_test] = step_min(g, H, Func_T_M, define_x, M, new_g_add, t_id)
I = eye(length(define_x));
x = sym('x', [1 length(define_x)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Vectors, Diag] = eig(H);
e = eig(H);
e_min = max([0, -min(e)]);
%x_e = C * x_f  => x_f = inv(C) * x_e
g_new = inv(Vectors) * g;
%g_new = [-1; 0];
%H = [0 0; 0 -1];
for i = 1:length(g_new)
    if g_new(i) == 0
        g_new(i) = new_g_add;
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
%all_ok_roots{num};
%true_value;
x_k = all_ok_roots{num} + define_x;
value = true_value;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x_k_test, value_test] = step_min_test(g, H, Func_T_M, define_x, M, t_id);
x_k_test = x_k_test + define_x;
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