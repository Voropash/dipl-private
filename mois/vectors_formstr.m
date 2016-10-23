function [out] = vectors_formstr(varargin)
    form_str = '';
    length_mas = cellfun('length', varargin);
    for i = 1:length(varargin)
        if isvector(varargin(i))
            for j = 1:length_mas(i)
                d = varargin{i}(j);
                type_for_cat = '';
                if isinteger(d)
                    type_for_cat = ' %5d';
                    dop_z_type =   '%d';
                else
                    type_for_cat = ' %10.4e';
                    dop_z_type =   ' %.4e';
                end
                if isreal(d)
                    form_str = strcat(form_str, type_for_cat);
                else
                    if imag(d) ~= 0
                        form_str = strcat(form_str, type_for_cat, ' + ', dop_z_type, 'i;');
                    else
                        form_str = strcat(form_str, type_for_cat, dop_z_type, 'i;');
                    end
                end
            end
        end
    end
    %form_str = strcat(form_str, '\r\n');
    out = form_str;
end