function [vargout] = cubic_regularization(params)
 %проверям есть ли информация - какие итерации выводить в файл
 if ischar(params('iterformat'))
     iter_format = iterformat(1000);
 else
     iter_format = params('iterformat');
 end
 %проверям - есть для второго варианта вывода информации в файл точка к
 %которой должно сойтись - x*, если нет - берем 0
if ischar(params('x*')) & strcmp(params('output_format'),'second')
    params('x*') = zeros(1000, 1)';
end
%запоминаем часто встречающиеся обозначения чтобы не дергать кажды раз из
%params
iter = 1;
x_k = params('start_point');
func   = params('func');
func_g = params('grad');
func_H = params('Hes');
%генерация функции, для которой ищется минимум Func_T_M
    x = sym('x', [length(x_k) 1]);  
    g = sym('g', [length(x_k) 1]);
    H = sym('H', [length(x_k) length(x_k)]);
    syms M;
    Func_T_M = dot(g, x) + 1/2*dot(H*x, x) + M/6*norm(x)^3;
    Func_T_M = matlabFunction(Func_T_M, 'vars', {x, g, H, M});
M = params('L_0');
while 1
    %сваливаем как только норма градиента будет достаточна мала, или цикл сработает больше, чем надо
    break_condition = not (norm(func_g(x_k)) > params('precission') && iter < length(iter_format) );
    if isa(params('file'), 'double') && (iter_format(iter) || break_condition )   %делаем вывод если есть id файла - и указание для итерации, и последнюю тоже выведем
        gr = double(norm(func_g(x_k)));
        if strcmp(params('output_format'), 'first')
            form_str = '%6d %15.4e %15.4e %10.4f %15.4e';
            form_str = strcat(form_str, ' |  ', vectors_formstr(x_k));
            form_str = strcat(form_str, '\r\n');
            e = eig(func_H(x_k));
            e_min = min(e);
            fprintf(params('file'), form_str, iter, gr, func(x_k), M, e_min, x_k);
        elseif strcmp(params('output_format'), 'second')
            %fprintf(varargin{1}, '65d %20.8f %20.8f %20.8f %5.2f\r\n', i, double(func(x_k) - func(xstar)), gr, norm(x_k - xstar, 2), Step);
            fprintf(params('file'), '%6d %15.4f %15.4f %15.4f %15.4f\r\n', iter, double(func(x_k) - func(params('x*'))), gr, norm(x_k - params('x*')), Step);
        end;
    end;
    if break_condition
        break;
    end
%собственно сам метод------------------------------------------------------
    exit_flag = 1;
    %M = params('L_0');       
    while(exit_flag == 1)
        [T_M, value] = step_min(params, Func_T_M, x_k, M);
        if func(T_M) <= value + func(x_k)
            x_k = T_M;
            exit_flag = 0;
        else
            M = 2*M;
        end
    end    
%--------------------------------------------------------------------------
    iter = iter+1;
end
vargout = x_k;
if norm(func_g(x_k)) < eps
    %disp('Yes')
    %disp(iter)
    %disp(x_k)
else
    %disp('No')
    %disp(x_k)
end