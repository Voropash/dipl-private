function [S] = test_U(U, Z, ballance_node, U_0)
[out] = Cond_matrix(Z);
G = out{1};
B = out{2};
Y = G + B*1i;
Y(ballance_node, :) = []; 
Y_ballance = Y(:, ballance_node);
Y(:, ballance_node) = [];
for i = 1:length(U)/2
    U(i) = U(i) +U(length(U)/2 + i)*j;
end;
U(length(U)/2+1:length(U)) = [];
S = conj(diag(U))*(Y*U + Y_ballance.*U_0);
S = -conj(S);