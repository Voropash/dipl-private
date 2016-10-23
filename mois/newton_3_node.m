
    f_id = fopen('cubic_regularization_test_all.txt', 'w');
    %fprintf(f_id, '  iter         f(x_k)-f(x*)           grad(x_k)         norm(x_k - x*)\n');
    fprintf(f_id, '  iter           grad(x_k)         value                  vector\n');
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
    %[-715, 295]   [-786,219]j; [-600, 230] [-714, 173]j  
    S = [28.8675 + 17.3205*j, -46.1880 - 23.0940*j];
    U_0 = 115;
    [out] = cubic_system(S, Z, num_node, ballance_node, U_0);
    % %--------------------------------------------------------------------------
     u = [110; 110];
     v = [0; 0];
     x = [u; v];
     %F(x)
     %F_min(x)
     %g(x) 
     %H(x)
     x_star = [
             114.073328864181,
             119.32218113853,
             -0.24174115762623,
             4.17023103070188
            ];
     newtonbase(x, out{1}, out{2}, out{3}, 0.3, 0.00000001, 0.01, f_id, outformat, x_star);
