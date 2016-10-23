    num_node = 2;
    ballance_node = 1;
    Z = [   
               0        10 + 20*j;
            10 + 20*j      0     ;
        ];    
    S = [-500 - 500*j];
    U_0 = 115;
         u_test = [110];
     v_test = [0];
     x_test = [u_test, v_test]';

P = real(S)';
    Q = imag(S)';
    [out] = Cond_matrix(Z);
    G = out{1};
    B = out{2};
    G_sys = G;
    B_sys = B;
    g_0 = real(G(:, ballance_node) + B(:, ballance_node) * j)*U_0;
    g_0(ballance_node) = [];
    b_0 = imag(G(:, ballance_node) + B(:, ballance_node) * j)*U_0;
    b_0(ballance_node) = [];
    G_sys(:, ballance_node) = [];
    G_sys(ballance_node, :) = [];
    B_sys(:, ballance_node) = [];
    B_sys(ballance_node, :) = [];
    Y_sys = [G_sys -B_sys; B_sys G_sys];
    u = sym('u', [num_node-1 1]);
    v = sym('v', [num_node-1 1]);
    D = [diag(u) diag(v); diag(v) -diag(u)];
    x = [u; v];
    F = sym('F', [2*(num_node-1) 1]);
    F = [P; Q] + D*(Y_sys*x + [g_0; b_0]);
    D_F = [diag(F(1:num_node-1)) -diag(F(num_node:2*(num_node-1))); diag(F(num_node:2*(num_node-1))) diag(F(1:num_node-1))];
    J = [diag(G_sys*u - B_sys*v) diag(B_sys*u + G_sys*v); -diag(B_sys*u + G_sys*v) diag(G_sys*u - B_sys*v)] + [diag(g_0) diag(b_0); -diag(b_0) diag(g_0)] + D*Y_sys
    cs_g = (F'*J)';
    cs_H = J'*J + D_F*Y_sys + Y_sys'*D_F';
    F_min = 0.5*norm(F)^2;
    F = matlabFunction(F, 'vars', {x})
    F_min = matlabFunction(F_min, 'vars', {x});
    J = matlabFunction(J, 'vars', {x});
    cs_g = matlabFunction(cs_g, 'vars', {x});
    D_F = matlabFunction(D_F, 'vars', {x});
    cs_H = matlabFunction(cs_H, 'vars', {x});
    sprintf('%20.4f', cs_g(x_test))
    cs_H(x_test)