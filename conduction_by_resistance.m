%% conduct matrix, first string - balance node
DIM = 2; 
ResistanceMatrix = [ 0      10+20i  15+30i; % balance node
                    10+20i  0       10+25i;
                    15+30i  10+25i  0     ]; % Om
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
CM = -diag(sum(CM)) + CM

B = real(CM);
G = imag(CM);
B_s = real(ConductMatrix);
G_s = imag(ConductMatrix);

ConductMatrix_s = ConductMatrix;
ConductMatrix = CM;