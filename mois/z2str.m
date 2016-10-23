function [out] = z2str(z)
iter = 1;
for i = 1:length(z)
    if isreal(z(i))
        new_z(iter) = z(i);
        iter = iter + 1;
    else
        new_z(iter) = real(z(i));
        new_z(iter+1) = imag(z(i));
        iter = iter + 2;
    end
    out = new_z;
end