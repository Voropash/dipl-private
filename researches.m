%% 2 переменные
syms b real
syms g real
syms p real
syms q real
syms u_b real
b11 = -b;
g11 = -g;
b22 = -b;
g22  = -g;
g12 = g;
b12 = b;
b21 = b;
g21 = g;
B_syms = [b11,b12; b21, b22];
G_syms = [g11,g12; g21, g22];

B_syms = [b11,b12; b21, b22];
G_syms = [g11,g12; g21, g22];
u1 = u_b;
v1 = 0;
%syms us;
%solve( (g-b*1i)^(-1) * (-(g-b*1i) * u_b + conj(p+q*1i)./conj(us)) + us , us)
u2 =  ((b^4*u_b^4 - 4*b^3*q*u_b^2 + 2*b^2*g^2*u_b^4 - 4*b^2*g*p*u_b^2 - 4*b^2*p^2 - 4*b*g^2*q*u_b^2 + 8*b*g*p*q + g^4*u_b^4 - 4*g^3*p*u_b^2 - 4*g^2*q^2)^(1/2) + b^2*u_b^2 + g^2*u_b^2)/(2*(u_b*b^2 + u_b*g^2));
v2 = -((b*p - g*q))/(u_b*b^2 + u_b*g^2);
%2ое решение:
%u2 =  (b^2*u_b^2 - (b^4*u_b^4 - 4*b^3*q*u_b^2 + 2*b^2*g^2*u_b^4 - 4*b^2*g*p*u_b^2 - 4*b^2*p^2 - 4*b*g^2*q*u_b^2 + 8*b*g*p*q + g^4*u_b^4 - 4*g^3*p*u_b^2 - 4*g^2*q^2)^(1/2) + g^2*u_b^2)/(2*(u_b*b^2 + u_b*g^2));
%v2 = -((b*p - g*q))/(u_b*b^2 + u_b*g^2)

%syms u2 v2 real
u_syms = [u1; u2];
v_syms = [v1; v2];

J_syms = [diag(G_syms*u_syms-B_syms*v_syms), diag(B_syms*u_syms+G_syms*v_syms);
     -diag(B_syms*u_syms+G_syms*v_syms), diag(G_syms*u_syms-B_syms*v_syms)];

J_syms = J_syms + [diag(u_syms), diag(v_syms);
                   diag(v_syms), -diag(u_syms)] * [G_syms, -B_syms;
                                                   B_syms,  G_syms];
                                    
l1_syms = -1/(J_syms(2,2)*J_syms(4,4)-J_syms(2,4)*J_syms(4,2))  * (J_syms(4,4)*(J_syms(1,2)+J_syms(2,2))-J_syms(4,2)*(J_syms(1,4)+J_syms(2,4)));                
l3_syms = -1/(J_syms(2,2)*J_syms(4,4)-J_syms(2,4)*J_syms(4,2))  * (-J_syms(2,4)*(J_syms(1,2)+J_syms(2,2))+J_syms(2,2)*(J_syms(1,4)+J_syms(2,4)));

result = 2*(g*(1+l1_syms)-l3_syms*b);
                                
result = simplify(result)
%(2*g*u_b^2*(b^2 + g^2))/(b^4*u_b^4 - 4*b^3*q*u_b^2 + 2*b^2*g^2*u_b^4 - 4*b^2*g*p*u_b^2 - 4*b^2*p^2 - 4*b*g^2*q*u_b^2 + 8*b*g*p*q + g^4*u_b^4 - 4*g^3*p*u_b^2 - 4*g^2*q^2)^(1/2)


subsJ = subs(result,[b, g, p, q, u_b],[B_s,G_s,real(S), imag(S),balanceU])





%% 3 переменные
syms u
syms v
u_syms = [u1; u];
v_syms = [v1; v];

%% ћатрица якоби 
J_syms = [diag(G_syms*u_syms-B_syms*v_syms), diag(B_syms*u_syms+G_syms*v_syms);
     -diag(B_syms*u_syms+G_syms*v_syms), diag(G_syms*u_syms-B_syms*v_syms)];

 J_syms = J_syms + [diag(u_syms), diag(v_syms);
        diag(v_syms), -diag(u_syms)] * [G_syms, -B_syms;
                                        B_syms,  G_syms];
                                
%% отбрасываем первый и (DIM+2) столбцы ћатрицы якоби
J_syms_s = [J_syms(2 : DIM+1, 2 : DIM+1)         J_syms(2 : DIM+1, DIM+3 : 2*DIM+2);
        J_syms(DIM+3 : 2*DIM+2, 2 : DIM+1)   J_syms(DIM+3 : 2*DIM+2, DIM+3 : 2*DIM+2)];
 
%% dl/dx = cумма первых строк  ћатрицы якоби
l_syms_x = J_syms(1 : DIM+1, 1 : 2*DIM+2);
l_syms_x = transpose(sum(l_syms_x));
l_syms_x = [l_syms_x(2 : DIM+1); l_syms_x(DIM+3 : 2*DIM+2)];

%% –ешаем систему
l_syms_s = - transpose( transpose(l_syms_x) *((J_syms_s)^(-1)));





%Hessian_FULL_s(1,1) - subsJ(1,1)








syms b1 real
syms g1 real
syms b2 real
syms g2 real
syms u_b real
syms p1 p2 q1 q2 real;
S_syms = [p1+1i*q1; p2 + 1i*q2];
%ResistanceMatrix = [0 g1-1i*b1 inf; g1-1i*b1 0 g2-1i*b2; inf g2-1i*b2 0];
DIM = 2;

%% V-obraznaya set' 
G = [g1+g2 -g1 -g2; -g1 g1 0; -g2 0 g2];
B = [b1+b2 -b1 -b2; -b1 b1 0; -b2 0 b2];
G_s = -[g1 0; 0 g2];
B_s = -[b1 0; 0 b2];

%% liniya s izlomom 
G = [g1 -g1 0; g1 -g1-g2 g2; 0 g2 -g2];
B = [-b1 b1 0; b1 -b1-b2 b2; 0 b2 -b2];
G_s = -[ -g1-g2 g2; g2 -g2];
B_s = -[ -b1-b2 b2; b2 -b2];

%%
ConductMatrix_s =  G_s - B_s*1i;
ConductMatrix = G - B*1i;

syms u1_c v1_c u2_c v2_c real;
u1=u1_c+1i*v1_c;
u2=u2_c+1i*v2_c;
us = [u1; u2];
[x,y,z,t] = solve( (ConductMatrix_s)^(-1) * (-ConductMatrix(2:DIM+1,1) * u_b - conj(S_syms)./conj(us)) + us , [u1_c,v1_c,u2_c,v2_c])

uur =(ConductMatrix_s)^(-1) * (-ConductMatrix(2:DIM+1,1) * u_b - conj(S_syms)./conj(us)) + us;
eval(uur)
        
