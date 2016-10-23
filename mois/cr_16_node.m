%задаем условия задачи
    num_node = 16;
    ballance_node = 16;
name_node = [40 42 73 136 186 187 206 207 209 212 214 220 222 228 397 700];
node_from = [397 73 186 206 206 206 206 206 209 209 212 214 214 222 222 228];
node_to = [207 212 206 40 42 220 228 700 187 207 207 212 222 136 187 73];
r = [7.74 2.2 2.4 0.6 0.6 6.2 0.8 4.12 2.2 1.2 0.4 3.5 3.6 7.8 1.9 0.3];
x = [38.41 13.2 12.6 3.1 3.1 31.6 4.7 23.14 11.6 6.2 2.4 17 19.3 31.2 10 1.9];
b = [-262.99999 -99 -83 -21 -21 -210 -31 -152.4 -78 -40 -16 -111 -130.99999 -204 -69 -13];

Z = zeros(16, 16);
B = zeros(16, 16);
for i = 1:16
    Z(find(name_node==node_from(i)), find(name_node==node_to(i))) = r(i) + x(i)*j;
    Z(find(name_node==node_to(i)), find(name_node==node_from(i))) = r(i) + x(i)*j;
    B(find(name_node==node_from(i)), find(name_node==node_to(i))) = b(i);
    B(find(name_node==node_to(i)), find(name_node==node_from(i))) = b(i);
end
B = B*j;
real_z = real(Z);
imag_z = imag(Z);
%Y = Cond_matrix(Z, B);
      
    S = rand(1, 15)*(1 + 0.8i);
    S = [0.78203, 4.012712, -6.45068, -6.45086, -5.59356, -4.30349, 190.7697, -3.49422, -1.86383, 659.4273, -0.39498, -3.81818, -0.16991, -3.15909, 14.52273];
    U_0 = 226.04613;
    [out] = cubic_system(S, {Z, B}, num_node, ballance_node, U_0);
    u = ones(1, 15)*220;
    v = zeros(1, 15);
    x = [u, v]';
%      x_star = [
%              114.073328864181,
%              119.32218113853,
%              -0.24174115762623,
%              4.17023103070188
%             ];
%задаем доп данные для вывода
    f_id = fopen('cr_16_node.txt', 'w');
    t_id = fopen('cr_16_node_stepmin.txt', 'w');
    iter_format = iterformat(3000);%это одномерный массив, 1/0 в i ячейке = вывод/не вывод i-й итерации
%запихиваем все параметры метода в одну структуру 
     keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'L_0', 'new_g_add', 'step_min_var', 'file', 'file_test', 'iterformat', 'output_format', 'output_format_test', 'x*', 'x*_test' 'mod_test', 'Step_test', 'lambda_0', 'betta', 'sigma'};
     valueSet = { x,             out{1}, out{2}, out{3},1e-6,         0.3 ,    1e-2    , 'first'       ,  f_id,   t_id,        iter_format, 'first',         'first'             , 'no', 'no',   'drob'       ,     0.1,            0.5,       0.6,     0.6   };
     params = containers.Map(keySet,valueSet);
%делаем вывод в файл заголовка в зависимости от варианта вывода
     if strcmp(params('output_format'), 'first')
        fprintf(f_id, '%6s %15s %15s %10s', 'iter', 'grad(x_k)', 'value', 'M');   
        fprintf(f_id, '%13s', 'x(1)')
        for i = 2:length(x)
           fprintf(f_id, '%11s', strcat('x(', int2str(i), ')')) 
        end
        fprintf(f_id,'\r\n')    
     elseif strcmp(params('output_format'), 'second')
        fprintf(f_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
     if strcmp(params('output_format_test'), 'first')
        fprintf(t_id, '%6s %15s %15s %10s %10s\r\n', 'iter', 'grad(x_k)', 'value', 'Step', 'vector');     
     elseif strcmp(params('output_format_test'), 'second')
        fprintf(t_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
%запускаем метод, на выход получаем точку
      x_k = cubic_regularization(params);
%выводим все собственные числа, и после минимальное собств число
     e = eig(out{3}(x_k));
     form_str = 'eigenvalues: ';
     for i = 1:length(e)
        form_str = strcat(form_str, ' %10.4f'); 
     end
     form_str = strcat(form_str, '\r\n');
     fprintf(f_id, form_str, e);
     e_min = min(e);
     fprintf(f_id, 'e_min = %10.4f\n', e_min);
%проверям конечную точку - подставляем в систему уравнений из Идельчика,
%получаем нагрузку исходную, по крайней мере должны получить
    test_U(x_k, Z, ballance_node, U_0);