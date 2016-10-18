%% 3.2 Idelchik
%% dimention
DIM = 2;
%% balanse
balanceU = 110+0*1i; %kW
%% conduct matrix
conduction_by_resistance;
%% power load
% Potreblenie
S_Base = [20+16*1i; 20+16*1i]; %mV
S = S_Base;



ConductMatrix_s = [0.0338-0.0745i -0.0138+0.0345i;
                -0.0138+0.0345i  0.0271-0.0612i];
ConductMatrix = [  0.0333-0.0667i -0.02+0.04i     -0.0133+0.0267i;
                    -0.02+0.04i      0.0338-0.0745i -0.0138+0.0345i;
                    -0.0133+0.0267i -0.0138+0.0345i  0.0271-0.0612i];
G = real(ConductMatrix);
B = -imag(ConductMatrix);

G_s = real(ConductMatrix_s);
B_s = -imag(ConductMatrix_s);

balanceU = 115;
DIM = 2;
S_Base = [28.8675+17.3205*1i; -46.1880-23.0940*1i];



%% dimention
DIM = 15;
%% constants
MAX_NUMBER_OF_ITERATIONS = 2500;
PRECISION = 0.0000001;
%% balanse
balanceU = 220; %110+0*i; %kW
%% power load
%S_Base = (rand(DIM,1)-0.5*ones(DIM,1))*2; %mV
%S_Base = ((1+0.8*1i)*ones(DIM,1)); %mV
%S_Base = [28.8675+17.3205*1i; -46.1880-23.0940*1i];
S_Base = [
    0.78203;
    4.012712;
    -6.45068;
    -6.45086;
    -5.59356;
    -4.30349;
    190.7697;
    -3.49422;
    -1.86383;
    659.4273;
    -0.39498;
    -3.81818;
    -0.16991;
    -3.15909;
    14.52273
    ];
S = S_Base;

