
    f_id = fopen('cr_3_node_test.txt', 'w');
    fprintf(f_id, '  iter           grad(x_k)                 value            vector\r\n');
    outformat = zeros(1000, 1);
    for i = 1:20
       outformat(i) = 1;
    end;
    for i = 2:5
       outformat(i*10) = 1;
    end;
    for i = 1:20
       outformat(i*50) = 1;
    end;
    num_node = 3;
    ballance_node = 1;
    Z = [   
               0        10 + 20*j 15 + 30*j ;
            10 + 20*j      0      10 + 25*j ;
            15 + 30*j   10 + 25*j    0      ; 
        ];
    %S = [ (-715, 295)   (-786,219)j; (-600, 230) (-714, 173)j ]
    S = [28.8675 - 786*j, -46.1880 - 23.0940*j];
    U_0 = 115;
    % %--------------------------------------------------------------------------
     u = [110; 110];
     v = [0; 0];
     x = [u; v];
     x_star = [
             114.073328864181,
             119.32218113853,
             -0.24174115762623,
             4.17023103070188
            ];
     

P = -786: 10: 219;
res1 = [];
res2 = [];
for k = 1 : length(P)
    %S(1) = S(1) + 10;
    S(1) = S(1) + 10*j;
    %S(3) = S(3) + 1;
    %S(3) = S(3) + 1*j;
    form_str = 'S = [';
    S_mas = [];
    for i = 1: length(S)
        form_str = strcat(form_str, ' %.3f + %.3fi,');
        S_mas(i*2 - 1) = real(S(i));
        S_mas(i*2) = imag(S(i));
    end
    form_str = form_str(1:length(form_str)-1);
    form_str = strcat(form_str, ' ]-----------------------------------------------------------------------------------------\r\n');
    fprintf(f_id, form_str, S_mas);
    [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
    [result, iters] = cubic_regularization(x, out{1}, out{2}, out{3}, 0.5, 0.000001, 0.01, f_id, outformat, x_star);
    e = eig(out{3}(result));
    e_min = min(e);
    fprintf(f_id, ' e_min = %10.4f\r\n', e_min);  
end