function [vargout] = Cond_matrix(varargin)
    l = length(varargin);
    l_test = length(varargin{1});
    Z = varargin{1};
    if l > 1
        B = varargin{2};
    elseif l==1 && l_test == 2 && isa(Z, 'cell')
        B = Z{2};
        Z = Z{1};
    end
    N = size(Z, 1);
    Y = zeros(N);
    for i = 1 : N
       for j = 1 : N
          if i ~= j
             if Z(i, j) ~= 0
                Y(i, j) = -1/Z(i, j); 
             end
          end
       end
    end
    for i = 1 : N
       for j = 1 : N
          if i ~= j  
             Y(i, i) = Y(i, i) - Y(i, j);
             if l > 1
                 Y(i, i) = Y(i, i) + B(i, j);
             end
          end
       end
    end
    Y
    vargout{1} = real(Y);
    vargout{2} = imag(Y);