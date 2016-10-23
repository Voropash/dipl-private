
    f_id = fopen('gr_2_node.txt', 'w');
    %fprintf(f_id, '  iter         f(x_k)-f(x*)           grad(x_k)         norm(x_k - x*)\n');
    fprintf(f_id, '  iter           grad(x_k)         value                  vector\n');
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
    num_node = 2;
    ballance_node = 1;
    Z = [   
               0        10 + 20*j;
            10 + 20*j      0     ;
        ];
    %S = [ (-715, 295)   (-786,219)j; (-600, 230) (-714, 173)j ]  
    S = [-10 - 50*j];
    U_0 = 115;
    [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
    % %--------------------------------------------------------------------------
     u = [110];
     v = [0];
     x = [u, v]';
     x_star = [ 123.8283, -2.6087]';
     gradientbase(x, out{1}, out{2}, 0.0000001, 0.01, f_id, outformat, x_star);