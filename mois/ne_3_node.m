%������ ������� ������
    num_node = 3;
    ballance_node = 1;
    Z = [   
               0        10 + 20*j 15 + 30*j ;
            10 + 20*j      0      10 + 25*j ;
            15 + 30*j   10 + 25*j    0      ; 
        ];
      
    S = [28.8680- 719i, -46.1880 - 23.094i];
    U_0 = 115;
    [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
    u = [110, 110];
    v = [0, 0];
    x = [u, v]';
    x_star = [ 114.073328864181, 119.32218113853, -0.24174115762623, 4.17023103070188]';
%������ ��� ������ ��� ������
    f_id = fopen('ne_3_node.txt', 'w');
    iter_format = iterformat(3000);%��� ���������� ������, 1/0 � i ������ = �����/�� ����� i-� ��������
%���������� ��� ��������� ������ � ���� ��������� 
     keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'Step', 'file', 'iterformat', 'output_format', 'x*', 'mod', 'lambda_0', 'betta', 'sigma'};
     valueSet = { x,             out{1}, out{2}, out{3},1e-6,         1.0,    f_id,   iter_format, 'first',        x_star, 'drob'       ,  0.5,       0.6,     0.6   };
     params = containers.Map(keySet,valueSet);
%������ ����� � ���� ��������� � ����������� �� �������� ������
     if strcmp(params('output_format'), 'first')
        fprintf(f_id, '%6s %15s %15s %10s', 'iter', 'grad(x_k)', 'value', 'Step');   
        fprintf(f_id, '%13s', 'x(1)')
        for i = 2:length(x)
           fprintf(f_id, '%11s', strcat('x(', int2str(i), ')')) 
        end
        fprintf(f_id,'\r\n')   
     elseif strcmp(params('output_format'), 'second')
        fprintf(f_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
%��������� �����, �� ����� �������� �����
      x_k = newtonbase(params);
%������� ��� ����������� �����, � ����� ����������� ������ �����
     e = eig(out{3}(x_k));
     form_str = 'eigenvalues: ';
     for i = 1:length(e)
        form_str = strcat(form_str, ' %20.4f'); 
     end
     form_str = strcat(form_str, '\r\n');
     fprintf(f_id, form_str, e);
     e_min = min(e);
     fprintf(f_id, ' e_min = %10.4f\n', e_min);
%�������� �������� ����� - ����������� � ������� ��������� �� ���������,
%�������� �������� ��������, �� ������� ���� ������ ��������
    test_U(x_k, Z, ballance_node, U_0);