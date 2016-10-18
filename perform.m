U = -ones(DIM, 1) * 220;
[U,fval,exitflag,output,jacobian] = fsolve(@UUR, U ,optimset('MaxFunEvals',10000,'MaxIter', 10000, 'TolX', 0, 'Algorithm', {'levenberg-marquardt',.01}, 'ScaleProblem', 'Jacobian'), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);

U_previousIteration = U; 
counterOfIterations = 0;
flagNotSeries = false;
I = -conj(S)./conj(U);
while (sum(abs(UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )))>PRECISION)
    U_previousIteration = U;
    %sum(abs(UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )))
    U_new = (ConductMatrix_s)^(-1) * (-ConductMatrix(2:DIM+1,1) * balanceU + I); % resolve linear system    
    I = -conj(S)./conj(U); % vector operation
  
    counterOfIterations = counterOfIterations + 1;
        if (counterOfIterations>2)
            %flagNotSeries = true;
            disp(counterOfIterations);
            break;
        end
end
format longG;
%flagNotSeries
%disp(counterOfIterations)
%UUR( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )

%[U,fval,exitflag,output,jacobian] = fsolve(@UUR, U ,optimset('MaxFunEvals',5000,'MaxIter', 100, 'TolX', 0, 'Algorithm', {'levenberg-marquardt',.1}), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);
%[x,fval,exitflag,output,grad,hessian] = fminunc(@lost_function, ones(DIM,1)*220,optimset('Display', 'off','MaxFunEvals',15000000,'MaxIter',300), ConductMatrix,ConductMatrix_s,DIM,S,balanceU);

u = [balanceU; real(U)];
v = [0; imag(U)];
%output.iterations
if (output.iterations >= 100) 
    flagNotSeries = true;
end

sum_abs_uur( U,ConductMatrix,ConductMatrix_s,DIM,S,balanceU )

Gessianius;
