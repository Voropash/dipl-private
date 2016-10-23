function [vargout] = Rosenbrock(dimention)
    syms Rosenbrock_f(x) Rosenbrock_g(x) Rosenbrock_h(x);
    x = sym('x', [1 dimention]);
    temp = (1 - x(1))^2;
    for i = 2: dimention
        temp = temp + 5*(x(i) - x(i-1)^2)^2;
    end;
    Rosenbrock_f(x) = temp;
    Rosenbrock_g(x) = gradient(Rosenbrock_f, x);
    Rosenbrock_h(x) = hessian(Rosenbrock_f,x);
    vargout{1} = Rosenbrock_f;
    vargout{2} = Rosenbrock_g;
    vargout{3} = Rosenbrock_h;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
