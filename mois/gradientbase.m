 function [vargout] = gradientbase(x, func, func_g, eps, Step, varargin)
if length(varargin) < 2
    outformat = zeros(1000, 1);
else
    outformat = varargin{2};
end;
if length(varargin) < 3
    xstar = zeros(1000, 1)';
else
    xstar = varargin{3};
end;
x_k = x;
vargout{1} = x_k;
    if length(varargin) >= 1 & outformat(1)
        gr = double(norm(func_g(x_k), 2));
        %fprintf(varargin{1}, '%5d %20.8f %20.8f %20.8f %5.2f\n', 1, double(func(x_k) - func(xstar)), gr, norm(x_k - xstar, 2), Step);
        form_str = '%5d %20.4f %20.4f';
        for i = 1:length(x_k)
            form_str = strcat(form_str, ' %20.4f'); 
        end
        form_str = strcat(form_str, '\n');
        fprintf(varargin{1}, form_str, 1, gr, func(x_k), x_k);
    end;
x_k = x_k - Step*func_g(x_k);
iter = 2;
while (norm(func_g(x_k), 2) > eps && iter < 10000 )
    vargout{iter} = x_k;
    if length(varargin) >= 1 & outformat(iter)
        %gr = double(norm(func_g(x_k), 2));
        %fprintf(varargin{1}, '%5d %20.8f %20.8f %20.8f %5.2f\n', i, double(func(x_k) - func(xstar)), gr, norm(x_k - xstar, 2), Step);
            gr = double(norm(func_g(x_k)));
            form_str = '%5d %20.4f %20.4f';
            for i = 1:length(x_k)
               form_str = strcat(form_str, ' %20.4f'); 
            end
            form_str = strcat(form_str, '\n');
            %fprintf(varargin{1}, '%5d %20.8f %20.8f %20.8f\n', iter, double(func(x_k) - func(x_star)), gr, norm(x_k - x_star));
            fprintf(varargin{1}, form_str, iter, gr, func(x_k), x_k);
    end;
    iter = iter+1;
    x_k = x_k - Step * func_g(x_k);
end
if norm(func_g(x_k), 2) < eps
    disp('Yes')
    disp(iter)
    disp(x_k)
    if length(varargin) >= 1
            gr = double(norm(func_g(x_k)));
            form_str = '%5d %20.4f %20.4f';
            for i = 1:length(x_k)
               form_str = strcat(form_str, ' %20.4f'); 
            end
            form_str = strcat(form_str, '\n');
            %fprintf(varargin{1}, '%5d %20.8f %20.8f %20.8f\n', iter, double(func(x_k) - func(x_star)), gr, norm(x_k - x_star));
            fprintf(varargin{1}, form_str, iter, gr, func(x_k), x_k);
    end;
else
    disp('No')
    disp(x_k)
end