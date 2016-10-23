%������ ������� ������
    num_node = 3;
    ballance_node = 1;
    Z = [   
               0        10 + 20*j 15 + 30*j ;
            10 + 20*j      0      10 + 25*j ;
            15 + 30*j   10 + 25*j    0      ; 
        ];
      
    S = [28.868 + -719.000i, -46.1880 - 23.094i];
    U_0 = 115;
    [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
    u = [110, 110];
    v = [0, 0];
    x = [u, v]';
     x_star = [
             114.073328864181,
             119.32218113853,
             -0.24174115762623,
             4.17023103070188
            ];
%������ ��� ������ ��� ������
    f_id = fopen('cr_3_node.txt', 'w');
    t_id = fopen('cr_3_node_stepmin.txt', 'w');
    iter_format = iterformat(3000);%��� ���������� ������, 1/0 � i ������ = �����/�� ����� i-� ��������
%���������� ��� ��������� ������ � ���� ��������� 
     keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'L_0', 'new_g_add', 'step_min_var', 'file', 'file_test', 'iterformat', 'output_format', 'output_format_test', 'x*', 'x*_test' 'mod_test', 'Step_test', 'lambda_0', 'betta', 'sigma'};
     valueSet = { x,             out{1}, out{2}, out{3},1e-6,         0.3 ,    1e-2    , 'first'       ,  f_id,   t_id,        iter_format, 'first',         'first'             , x_star, 'no',   'drob'       ,     0.1,            0.5,       0.6,     0.6   };
     params = containers.Map(keySet,valueSet);
%������ ����� � ���� ��������� � ����������� �� �������� ������
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
%��������� �����, �� ����� �������� �����
      x_k = cubic_regularization(params)
%������� ��� ����������� �����, � ����� ����������� ������ �����
     e = eig(out{3}(x_k));
     form_str = 'eigenvalues: ';
     for i = 1:length(e)
        form_str = strcat(form_str, ' %10.4f'); 
     end
     form_str = strcat(form_str, '\r\n');
     fprintf(f_id, form_str, e);
     e_min = min(e);
     fprintf(f_id, 'e_min = %10.4f\n', e_min);
%�������� �������� ����� - ����������� � ������� ��������� �� ���������,
%�������� �������� ��������, �� ������� ���� ������ ��������
    test_U(x_k, Z, ballance_node, U_0)
     
