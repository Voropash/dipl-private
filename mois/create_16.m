%name_node = [40 42 73 136 186 187 206 207 209 212 214 220 222 228 397 700];
%node_from = [397 73 186 206 206 206 206 206 209 209 212 214 214 222 222 228];
%node_to = [207 212 206 40 42 220 228 700 187 207 207 212 222 136 187 73];
name_node = [12, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 13, 14, 15, 16];
node_from = [15, 3, 5, 7, 7, 7, 7, 7, 9, 9, 10, 11, 11, 13, 13, 14];
node_to = [8, 10, 7, 12, 2, 1, 14, 16, 6, 8, 8, 10, 13, 4, 6, 3];
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
Y = Cond_matrix(Z);
f_id = fopen('matr_real_Z.txt', 'w');
fprintf(f_id, strcat(vectors_formstr(real_z(1, :)), '\r\n'), real_z);
f_id = fopen('matr_imag_Z.txt', 'w');
fprintf(f_id, strcat(vectors_formstr(imag_z(1, :)), '\r\n'), imag_z);
f_id = fopen('matr_real_Y.txt', 'w');
fprintf(f_id, strcat(vectors_formstr(Y{1}(1, :)), '\r\n'), Y{1});
f_id = fopen('matr_imag_Y.txt', 'w');
fprintf(f_id, strcat(vectors_formstr(Y{2}(1, :)), '\r\n'), Y{2});