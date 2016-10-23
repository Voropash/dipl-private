function [out] = armiho_step(f, g, x, lambda0, betta, sigma)
    lambda_k = 1;
    for m = 1:100
        if f(x - lambda0*betta^m*g(x)) <= f(x) - sigma*lambda0*betta^m*norm(g(x))^2
            lambda_k = sigma*lambda0*betta^m;
            break;
        end
    end
    if m == 100
        lambda_k = 1;
    end
    out = lambda_k;
