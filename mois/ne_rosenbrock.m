dim = 20;
x = sym('x', [dim 1]);
[out] = feval(@Rosenbrock, length(x));
out{1} = matlabFunction(out{1}, 'vars', {x});
out{2} = matlabFunction(out{2}, 'vars', {x});
out{3} = matlabFunction(out{3}, 'vars', {x});
x = zeros(1, dim)';
x_star = zeros(1, dim)';
x_star(1) = 1;
x(1) = -1;
for i = 2:dim
    x(i) = x(i - 1)^2 - 0.2;
    x_star(i) = 1;
end;

%задаем доп данные для вывода
    f_id = fopen('ne_rosenbrock_20.txt', 'w');
    iter_format = iterformat(3000);%это одномерный массив, 1/0 в i ячейке = вывод/не вывод i-й итерации
%запихиваем все параметры метода в одну структуру 
     keySet =   {'start_point', 'func', 'grad', 'Hes', 'precission', 'Step', 'file', 'iterformat', 'output_format', 'x*', 'mod'};
     valueSet = { x,             out{1}, out{2}, out{3},1e-6,         0.5,    f_id,   iter_format, 'first',        x_star, 'drob'};
     params = containers.Map(keySet,valueSet);
%делаем вывод в файл заголовка в зависимости от варианта вывода
    if strcmp(params('output_format'), 'first')
        fprintf(f_id, '%6s %15s %15s %10s', 'iter', 'grad(x_k)', 'value', 'Step');   
        fprintf(f_id, '%13s', 'x(1)')
        for i = 2:length(x)
           fprintf(f_id, '%11s', strcat('x(', int2str(i), ')')) 
        end
        fprintf(f_id,'\r\n')
     elseif strcmp(params('output_format'), 'second')
        fprintf(f_id, '%6s %15s %15s %20s %10s\r\n', 'iter', 'f(x_k)-f(x*)', 'grad(x_k)', 'norm(x_k - x*)', 'Step');
     end
%запускаем метод, на выход получаем точку
      x_k = newtonbase(params);