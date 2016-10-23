    iter_format = iterformat(10000);
    f_id = fopen('ne_rosen.txt', 'w');
    dim = 2;
    start_x = zeros(dim, 1);
    [out] = feval(@Rosenbrock, length(start_x));
    x = sym('x', [dim 1]);
    out{1} = matlabFunction(out{1}, 'vars', {x});
    out{2} = matlabFunction(out{2}, 'vars', {x});
    out{3} = matlabFunction(out{3}, 'vars', {x});
    %[iters] = newtonbase(start_x, out{1}, out{2}, out{3}, 0.0000001, 0.9, f_id, outformat, star_x);
keySet =   {'start_point', 'func', 'grad', 'Hes', 'precisson', 'Step', 'file', 'itersformat', 'output_format', 'x*', 'step_armiho', 'lambda0', 'betta', 'sigma'};
valueSet = { start_x,       out{1}, out{2}, out{3},1e-6,        0.01,   f_id,   iter_format,  'second',         'no', 'true'       ,  1.2,       0.6,     0.6 };
params = containers.Map(keySet,valueSet);
a = 'test';
if strcmp(params('output_format'),'first')
   disp('Yes') 
end
isa(f_id, 'double')