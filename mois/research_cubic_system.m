num_node = 2;
ballance_node = 1;
Z = [   
        0        10 + 20*j;
        10 + 25*j    0      ; 
    ];
S = [-711.1880 - 23.0940*j];
U_0 = 115;
% %--------------------------------------------------------------------------
u = [110];
v = [0];
x = [u, v];
[out] = cubic_system(S, Z, num_node, ballance_node, U_0);       
X0 = -1000:10:1000;
Y0 = -1000:10:1000;
[X, Y] = meshgrid(X0, Y0);
axes('Xlim', [X0(1), X0(length(X0))], 'Ylim', [Y0(1), Y0(length(Y0))]);
grid off;  
hold on;
xlabel('x1'); ylabel('x2')
s = size(X); Z=zeros(s);
for i = 1:s(1)
    for j = 1:s(2)
        Z(i, j) = out{1}([X(i, j), Y(i, j)]');
    end
end
mesh(X, Y, Z);
%contour3(X,Y,Z,[v, V]);
shading interp;