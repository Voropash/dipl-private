function [result, vargout] = cubic_regularization(x_start, func, func_g, func_H, L_0, eps, new_g_add, t_id, varargin)
iteration = zeros(1000, length(x_start));
    if length(varargin) < 2
        outformat = zeros(1000, 1);
    else
        outformat = varargin{2};
    end;
    if length(varargin) < 3
        x_star = zeros(1000, 1)';
    else
        x_star = varargin{3};   
    end;
    vargout{1} = x_start';
    x = sym('x', [length(x_start) 1]);  
    x_k = sym('x_k', [length(x_start) 1]);
    g = sym('g', [length(x_start) 1]);
    H = sym('H', [length(x_start) length(x_start)]);
    syms M;
    Func_T_M = dot(g, x) + 1/2*dot(H*x, x) + M/6*norm(x)^3;
    Func_T_M = matlabFunction(Func_T_M, 'vars', {x, g, H, M});
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x_k = x_start;
    iter = 1;
    if length(varargin) >= 1 & outformat(1)
        %fprintf(varargin{1}, '-----------------------------------------------------------------------------------------------------------------------------------\r\n')
        gr = double(norm(func_g(x_k)));
        %fprintf(varargin{1}, '%5d %20.8f %20.8f %20.8f\r\n', 1, double(func(x_k) - func(x_star)), gr, norm(x_k - x_star));
        form_str = '%5d %20.4f %20.4f';
        for i = 1:length(x_k)
            form_str = strcat(form_str, ' %20.4f'); 
        end
        form_str = strcat(form_str, '\r\n');
        fprintf(varargin{1}, form_str, iter, gr, func(x_k), x_k);
    end;
    while (norm(func_g(x_k)) > eps && iter <= 1000 )
        %iter
        exit_flag = 1;
        M = L_0;       
        while(exit_flag == 1)
            [x_k_1, value, x_k_1_test, value_test] = step_min(func_g(x_k), func_H(x_k), Func_T_M, x_k, L_0, new_g_add, t_id);
            %value = value_test;
            %x_k_1 = x_k_1_test;
            if value <= value + func(x_k_1)
                exit_flag = 0;
                x_k = x_k_1;
            else
                M = 2*M;
            end
        end
        iter = iter + 1;
        if length(varargin) >= 1 & outformat(iter)
            gr = double(norm(func_g(x_k)));
            form_str = '%5d %20.4f %20.4f';
            for i = 1:length(x_k)
               form_str = strcat(form_str, ' %20.4f'); 
            end
            form_str = strcat(form_str, '\r\n');
            %fprintf(varargin{1}, '%5d %20.8f %20.8f %20.8f\r\n', iter, double(func(x_k) - func(x_star)), gr, norm(x_k - x_star));
            fprintf(varargin{1}, form_str, iter, gr, func(x_k), x_k);
        end;
        vargout{iter} = x_k';
    end
    result = x_k;

