%задаем условия задачи
    num_node = 16;
    ballance_node = 12;
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
    S = ones(1, 15)*(-500 - 0.8*500i);  
    %S = rand(1, 15)*(1 + 0.8i);
    %S = [0.8147 + 0.6518i   0.9058 + 0.7246i   0.1270 + 0.1016i   0.9134 + 0.7307i   0.6324 + 0.5059i   0.0975 + 0.0780i 0.2785 + 0.2228i   0.5469 + 0.4375i   0.9575 + 0.7660i   0.9649 + 0.7719i   0.1576 + 0.1261i   0.9706 + 0.7765i 0.9572 + 0.7657i   0.4854 + 0.3883i   0.8003 + 0.6402i]
    U_0 = 226.04613;
    [out] = cubic_system(S, {Z, B}, num_node, ballance_node, U_0);
    u = ones(1, 15)*220;
    v = zeros(1, 15);
    x = [u, v]';
%задаем доп данные для вывода
    f_id = fopen('cr_16_node_test.txt', 'w');
    t_id = fopen('cr_16_node_test_stepmin_ne.txt', 'w');
    iter_format = iterformat(3000);%это одномерный массив, 1/0 в i ячейке = вывод/не вывод i-й итерации
%запихиваем все параметры метода в одну структуру 
     keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'L_0', 'new_g_add', 'step_min_var', 'file', 'file_test', 'iterformat', 'output_format', 'output_format_test', 'x*', 'x*_test' 'mod_test', 'Step_test', 'lambda_0', 'betta', 'sigma'};
     valueSet = { x,             out{1}, out{2}, out{3},1e-6,         0.3 ,    1e-2    , 'first'       ,  f_id,   t_id,        iter_format, 'first',         'first'             , 'no', 'no',   'drob'       ,     0.1,            0.5,       0.6,     0.6   };
     params = containers.Map(keySet,valueSet);
%делаем вывод в файл заголовка в зависимости от варианта вывода
     if strcmp(params('output_format'), 'first')
        fprintf(f_id, '%6s %15s %15s %10s %10s %10s\r\n', 'iter', 'grad(x_k)', 'value', 'Step', 'lambda', 'vector');     
     elseif strcmp(params('output_format'), 'second')
        fprintf(f_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
     if strcmp(params('output_format_test'), 'first')
        fprintf(t_id, '%6s %15s %15s %10s %10s\r\n', 'iter', 'grad(x_k)', 'value', 'Step', 'vector');     
     elseif strcmp(params('output_format_test'), 'second')
        fprintf(t_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
%запускаем цикл для прогонки
    P = -720 : 10: 300;
    for k = 1 : length(P)
        form_str = strcat('S = [', vectors_formstr(S), ' ]-----------------------------------------------------------------------------------------\r\n');
        fprintf(f_id, form_str, z2str(S));
        [out] = cubic_system(S, {Z, B}, num_node, ballance_node, U_0);
        disp('YES')
        params('func') = out{1};
        params('grad') = out{2};
        params('Hes')  = out{3};
        x_k = cubic_regularization(params);
        e = eig(out{3}(x_k));
        form_str = strcat('eigenvalues: ', vectors_formstr(e), '\r\n');
        fprintf(f_id, form_str, e);
        e_min = min(e);
        fprintf(f_id, 'e_min = %10.4f\r\n', e_min);
%меняем нагрузку       
        %S(1) = S(1) + 1;
        S = S*2;
    end