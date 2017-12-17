%% conduct matrix, first string - balance node 
%% ћатрица проводимости из идельчика
DIM = 2;
ResistanceMatrix = [ 0      10+20i  15+30i; % balance node
                    10+20i  0       10+25i;
                    15+30i  10+25i  0     ]; % Om
%% ћатрица проводимости дл€ доказательства ветвлени€ 1
DIM = 1;
ResistanceMatrix = 2*[ 0      10+20i; % balance node
                    10+20i  0]; % Om
S_Base = -[28.8675+17.3205*1i];
%% ћатрица проводимости дл€ доказательства ветвлени€ 2
DIM = 2;
ResistanceMatrix = [ 0      10+20i  10+20i; % balance node
                    10+20i  0       inf;
                    10+20i  inf     0     ]; % Om
S_Base = -[28.8675+17.3205*1i; 28.8675+17.3205*1i];
%% ћатрица проводимости дл€ доказательства ветвлени€ 3
DIM = 2;
ResistanceMatrix = [ 0      10+20i  inf; % balance node
                    10+20i  0       10+20i;
                    inf     10+20i  0     ]; % Om
S_Base = -[28.8675+17.3205*1i; 0];
%% ћатрица проводимости дл€ доказательства ветвлени€ 4
DIM = 2;
ResistanceMatrix = [ 0      10+20i  inf; % balance node
                    10+20i  0       10+20i;
                    inf     10+20i  0     ]; % Om
S_Base = -[28.8675+17.3205*1i; 28.8675+17.3205*1i];
%% ћатрица проводимости дл€ доказательства ветвлени€ 5
DIM = 2;
ResistanceMatrix = [ 0      10+20i  20+40i; % balance node
                    10+20i  0       inf;
                    20+40i  inf     0     ]; % Om
S_Base = -[28.8675+17.3205*1i; 28.8675+17.3205*1i];
%% ћатрица проводимости из бублика –увимовича
DIM = 2;
ResistanceMatrix = [ 0      0+20i  0+20i; % balance node
                    0+20i  0       0.5+sqrt(3)/2 * 1i;
                    0+20i  0.5+sqrt(3)/2 * 1i     0     ]; % Om
%% „уть более положительна€ матрица проводимости из бублика –увимовича
DIM = 2;
ResistanceMatrix = [ 0      10+5i  10+5i; % balance node
                    10+5i  0       0.5+sqrt(3)/2 * 1i;
                    10+5i  0.5+sqrt(3)/2 * 1i     0     ]; % Om
%%
S = S_Base;
%% DIM*DIM
ConductMatrix = zeros;
for j = 2:1:DIM+1
    for g = 2:1:DIM+1
        if j ~= g
            ConductMatrix(j-1,g-1) = -1 / ResistanceMatrix(j,g);
        end
    end;
end;
sumVector = sum(ConductMatrix); % vector
for j = 1:1:DIM
    ConductMatrix(j,j) = -(sumVector(j) - 1/ResistanceMatrix(j+1,1));
end;
disp(ConductMatrix);

%% (DIM+1)*(DIM+1) matrix
CM = zeros;
for j = 1:1:DIM+1
    for g = 1:1:DIM+1
        if j ~= g
            CM(j,g) = 1 / ResistanceMatrix(j,g);
        end
    end;
end;
CM = diag(sum(CM)) - CM

B = -imag(CM);
G = real(CM);
B_s = -imag(ConductMatrix);
G_s = real(ConductMatrix);

ConductMatrix_s = ConductMatrix;
ConductMatrix = CM;