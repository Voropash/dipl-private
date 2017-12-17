s_Q = [ones(DIM, 1) * 110; zeros(DIM, 1)];
ii = [];
jj = [];
for i = 1.2:0.03:0.45
    for j = 1.2:0.03:0.45
       
        P = [i; j]
        [s_Q,fval,exitflag] = fsolve(@UURPOLAR2, s_Q ,optimset('Display','off'), V, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
        if exitflag == 1
            ii = [ii, i];
            jj = [jj, j];
        else 
            s_Q = [-1; -1; -1; -1];
            disp('!')
        end
    end
end
%for i = -1.2:0.0003:-0.85
%    i
%    P = [i; i+0.2];
%    [s_Q,fval,exitflag] = fsolve(@UURPOLAR2, s_Q ,optimset('Display','on', 'Algorithm', 'levenberg-marquardt', 'TolFun', 1e-9, 'TolX', 1e-9), V, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
%    if exitflag == 1
%        ii = [ii, i];
%        jj = [jj, i];
%    else 
%        s_Q = [-1; -1; -1; -1];
%        disp('!')
%    end
%end
scatter(ii, jj, 25, 'filled', 'red');