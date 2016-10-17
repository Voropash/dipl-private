%U = ones(DIM, 1) * 220;
%U_previousIteration = -U; 
%counterOfIterations = 0;
flagNotSeries = false;
%I = conj(S)./conj(U);
%while (sum(abs(U-U_previousIteration).*abs(U-U_previousIteration))>PRECISION)
%    U_previousIteration = U;
%    U = ones(DIM, 1) * balanceU + (ConductMatrix_s)^(-1) * I; % resolve linear system    
%    I = conj(S)./conj(U); % vector operation
%   % sum(abs(U-U_previousIteration).*abs(U-U_previousIteration))
%    counterOfIterations = counterOfIterations + 1;
%    if (counterOfIterations>MAX_NUMBER_OF_ITERATIONS)
%        flagNotSeries = true;
%        break;
%    end
%end
format longG;
%flagNotSeries
%disp(counterOfIterations)
%u = [balanceU; real(U)]
%v = [0; imag(U)]

[U,fval,exitflag,output,jacobian] = fsolve(@UUR, ones(DIM,1)*220,optimset('Display', 'off','MaxFunEvals',15000000,'MaxIter', 300), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);
%[x,fval,exitflag,output,grad,hessian] = fminunc(@lost_function, ones(DIM,1)*220,optimset('Display', 'off','MaxFunEvals',15000000,'MaxIter',300), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);

u = [balanceU; real(U)];
v = [0; imag(U)];
%output.iterations
if (output.iterations >= 100) 
    flagNotSeries = true;
end
Gessianius;
