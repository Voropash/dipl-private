 function [end_point, data] = newtonbase(params)
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
f   = params('func');
g = params('grad');
H = params('Hes');
Step = params('Step');
data{1} = x_k;
while 1
    %сваливаем как тольконорма градиента будет достаточна мала, или цикл сработает больше, чем надо
    break_condition = not (norm(g(x_k)) > params('precission') && iter < length(iter_format) );
    if isa(params('file'), 'double') && (iter_format(iter) || break_condition )   %делаем вывод если есть id файла - и указание для итерации, и последнюю тоже выведем
        gr = double(norm(g(x_k)));
        if strcmp(params('output_format'), 'first')
            form_str = '%6d %15.4e %15.4e %15.4e %15.4e';
            form_str = strcat(form_str, ' |  ', vectors_formstr(x_k));
            form_str = strcat(form_str, '\r\n');
            e = eig(H(x_k));
            e_min = min(e);
            fprintf(params('file'), form_str, iter, gr, f(x_k), Step, e_min, x_k);
        elseif strcmp(params('output_format'), 'second')
            %fprintf(varargin{1}, '65d %20.8f %20.8f %20.8f %5.2f\r\n', i, double(f(x_k) - f(xstar)), gr, norm(x_k - xstar, 2), Step);
            fprintf(params('file'), '%6d %15.4f %15.4f %15.4f %15.4f\r\n', iter, double(f(x_k) - f(params('x*'))), gr, norm(x_k - params('x*')), Step);
        end;
    end;
    iter = iter+1;
    %тут как раз ищем коэффециент по правилу Армихо
    if strcmp(params('mod'), 'armijo')
        Step = armiho_step(f, g, x_k, params('lambda_0'), params('betta'), params('sigma'))
        x_k = x_k - Step*(inv(H(x_k)) * g(x_k));
    elseif strcmp(params('mod'), 'drob')
        a=1;
        e = eig(H(x_k));
        e_min = min(e);
        new_H = H(x_k);
%         if e_min < 0 
%             e_min = 1.1*abs(e_min);
%             I = eye(length(H(x_k)));
%             I = I * e_min ;
%             new_H = H(x_k) + I;
%         end
        h= -1*inv(new_H)*g(x_k);
        local_iters = 1;
        while(f(x_k+a*h)>=f(x_k) && local_iters < 100)    
            a = a/2;
            local_iters = local_iters + 1;
        end
        if local_iters == 100
           a = 1;
        end
        x_k = x_k + a*h;
        Step = a
    elseif strcmp(params('mod'), 'base')
    %собственно сам метод Ньютона
        x_k = x_k - Step*(inv(H(x_k)) * g(x_k));
    end
    data{iter} = x_k;
    if break_condition
        break;
    end
end
end_point = x_k;
if norm(g(x_k)) < eps
    %disp('Yes')
    %disp(iter)
    %disp(x_k)
else
    %disp('No')
    %disp(x_k)
end