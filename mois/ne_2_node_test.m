%задаем условия задачи
    num_node = 2;
    ballance_node = 1;
        Z = [   
                   0        10 + 20*j;
                10 + 20*j      0     ;
            ];
      
    S = [28.868 - 719i];
    U_0 = 115;
    [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
    u = [110];
    v = [0];
    x = [u, v]';
    x_star = [ 123.8283, -2.6087]';
%задаем доп данные для вывода
    f_id = fopen('ne_2_node_test.txt', 'w');
    iter_format = iterformat(6000);%это одномерный массив, 1/0 в i ячейке = вывод/не вывод i-й итерации
%запихиваем все параметры метода в одну структуру 
     keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'Step', 'file', 'iterformat', 'output_format', 'x*', 'mod', 'lambda_0', 'betta', 'sigma'};
     valueSet = { x,             out{1}, out{2}, out{3},1e-6,         0.01,    f_id,   iter_format, 'first',        x_star, 'drob'       ,  1.2,       0.6,     0.6   };
     params = containers.Map(keySet,valueSet);
%делаем вывод в файл заголовка в зависимости от варианта вывода
     if strcmp(params('output_format'), 'first')
        fprintf(f_id, '%6s %15s %15s %10s %10s\r\n', 'iter', 'grad(x_k)', 'value', 'Step', 'vector');     
     elseif strcmp(params('output_format'), 'second')
        fprintf(f_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
%запускаем цикл для прогонки
    P = -720 : 10: 300;
    for k = 1 : length(P)
        form_str = strcat('S = [', vectors_formstr(S), ' ]-----------------------------------------------------------------------------------------\r\n');
        fprintf(f_id, form_str, z2str(S));
        [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
        params('func') = out{1};
        params('grad') = out{2};
        params('Hes')  = out{3};
        x_k = newtonbase(params);
        e = eig(out{3}(x_k));
        form_str = strcat('eigenvalues: ', vectors_formstr(e), '\r\n');
        fprintf(f_id, form_str, e);
        e_min = min(e);
        fprintf(f_id, 'e_min = %10.4f\r\n', e_min);
%меняем нагрузку       
        %S(1) = S(1) + 1;
        S(1) = S(1) + 10*1i;
    end