%% conduct matrix, first string - balance node

ResistanceMatrix = Inf(16,16);
%1
ResistanceMatrix(15,8) = 7.74+1i*38.41;
ResistanceMatrix(8,15) = 7.74+1i*38.41;
%2
ResistanceMatrix(3,10) = 2.2+1i*13.2;
ResistanceMatrix(10,3) = 2.2+1i*13.2;
%3
ResistanceMatrix(5,7) = 2.4+1i*12.6;
ResistanceMatrix(7,5) = 2.4+1i*12.6;
%4
ResistanceMatrix(7,1) = 0.6+1i*3.1;
ResistanceMatrix(1,7) = 0.6+1i*3.1;
%5
ResistanceMatrix(7,2) = 0.6+1i*3.1;
ResistanceMatrix(2,7) = 0.6+1i*3.1;
%6
ResistanceMatrix(7,12) = 6.2+1i*31.6;
ResistanceMatrix(12,7) = 6.2+1i*31.6;
%7
ResistanceMatrix(7,14) = 0.8+1i*4.7;
ResistanceMatrix(14,7) = 0.8+1i*4.7;
%8
ResistanceMatrix(7,16) = 4.12+1i*23.14;
ResistanceMatrix(16,7) = 4.12+1i*23.14;
%9
ResistanceMatrix(9,6) = 2.2+1i*11.6;
ResistanceMatrix(6,9) = 2.2+1i*11.6;
%10
ResistanceMatrix(9,8) = 1.2+1i*6.2;
ResistanceMatrix(8,9) = 1.2+1i*6.2;
%11
ResistanceMatrix(10,8) = 0.4+1i*2.4;
ResistanceMatrix(8,10) = 0.4+1i*2.4;
%12
ResistanceMatrix(11,10) = 3.5+1i*17;
ResistanceMatrix(10,11) = 3.5+1i*17;
%13
ResistanceMatrix(11,13) = 3.6+1i*19.3;
ResistanceMatrix(13,11) = 3.6+1i*19.3;
%14
ResistanceMatrix(13,4) = 7.8+1i*31.2;
ResistanceMatrix(4,13) = 7.8+1i*31.2;
%15
ResistanceMatrix(13,6) = 1.9+1i*10;
ResistanceMatrix(6,13) = 1.9+1i*10;
%16
ResistanceMatrix(14,3) = 0.3+1i*1.9;
ResistanceMatrix(3,14) = 0.3+1i*1.9;

%ResistanceMatrix(1,2) = 100+1i*20;
%ResistanceMatrix(2,1) = 100+1i*20;

ConductMatrix = zeros;
for j = 1:1:DIM+1
    for g = 1:1:DIM+1
        if j ~= g
            ConductMatrix(j,g) = -1 / ResistanceMatrix(j,g);
        end
    end;
end;
sumVector = sum(ConductMatrix); % vector
for j = 1:1:DIM+1
    ConductMatrix(j,j) = - (sumVector(j));
end;
vector_balance = zeros();
for j = 1:1:DIM+1
    vector_balance(j) = -sum(ConductMatrix(j,:));
end;

ConductMatrix_s =  ConductMatrix(2 : DIM+1, 2 : DIM+1);

G = real(ConductMatrix)
B = imag(ConductMatrix)

G_s = real(ConductMatrix_s);
B_s = imag(ConductMatrix_s);

%% trick
ConductMatrix_s = real(ConductMatrix_s) - 1i*imag(ConductMatrix_s);
                    