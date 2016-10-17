%задаем условия задачи
    num_node = 16;
    ballance_node = 16;
name_node = [40 42 73 136 186 187 206 207 209 212 214 220 222 228 397 700];
node_from = [397 73 186 206 206 206 206 206 209 209 212 214 214 222 222 228];
node_to = [207 212 206 40 42 220 228 700 187 207 207 212 222 136 187 73];
r = [7.74 2.2 2.4 0.6 0.6 6.2 0.8 4.12 2.2 1.2 0.4 3.5 3.6 7.8 1.9 0.3];
x = [38.41 13.2 12.6 3.1 3.1 31.6 4.7 23.14 11.6 6.2 2.4 17 19.3 31.2 10 1.9];
b = [-1/262.99999 -1/99 -1/83 -1/21 -1/21 -1/210 -1/31 -1/152.4 -1/78 -1/40 -1/16 -1/111 -1/130.99999 -1/204 -1/69 -1/13];
b = [-262.99999 -99 -83 -21 -21 -210 -31 -152.4 -78 -40 -16 -111 -130.99999 -204 -69 -13];

Z = zeros(16, 16);
B = zeros(16, 16);
for i = 1:16
    Z(find(name_node==node_from(i)), find(name_node==node_to(i))) = r(i) + x(i)*1i;
    Z(find(name_node==node_to(i)), find(name_node==node_from(i))) = r(i) + x(i)*1i;
    B(find(name_node==node_from(i)), find(name_node==node_to(i))) = b(i);
    B(find(name_node==node_to(i)), find(name_node==node_from(i))) = b(i);
end
B = B*1i;
real_z = real(Z);
imag_z = imag(Z);
Y = Cond_matrix(Z, B);
      
disp(Y{1})
disp(Y{2})

G = (Y{1}([ballance_node, 1:(ballance_node-1), (ballance_node+1):num_node],[ballance_node, 1:(ballance_node-1), (ballance_node+1):num_node]));
B = (Y{2}([ballance_node, 1:(ballance_node-1), (ballance_node+1):num_node],[ballance_node, 1:(ballance_node-1), (ballance_node+1):num_node]));

G_s = (G(2 : DIM+1, 2 : DIM+1));
B_s = (B(2 : DIM+1, 2 : DIM+1));

ConductMatrix = G + 1i*B;
%% trick
ConductMatrix_s = G_s + 1i*B_s;