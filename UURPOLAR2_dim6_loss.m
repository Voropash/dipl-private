function [ output_args ] = UURPOLAR2_dim6_loss( s_Q, V, ConductMatrix,ConductMatrix_s, DIM,P,balanceU )
    [s_Q,fval,exitflag,output,jacobian] = fsolve(@UURPOLAR2_dim6, s_Q ,optimset('Display', 'none', 'Algorithm', 'Levenberg-Marquardt'), V, ConductMatrix,ConductMatrix_s,DIM,P,balanceU);
    output_args = -s_Q(2*DIM+3)-P(1)-P(2);
end

    