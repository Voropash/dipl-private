mask2divk1 = [];
masQ = [];
for q = 0:1:60

    S_Base = real(S_Base)+q*1i;
    
masU = [];
masLambda = [];
masDiff = [];
masK = [];
S = S_Base;

for k = 0.01:2.1:1000
    S = S_Base * k;
    perform;
    if (flagNotSeries~=true)
            sizel = length(masLambda);
            if sizel > 2 && masLambda(sizel-1)>0 && uuu<0
                k_zero = k;
            end
    else
        k2 = k;
        break;
    end
end;
mask2divk1 = [mask2divk1,k_zero/k2];
masQ = [masQ,q];
disp(q);
end
plot(masQ, mask2divk1) 
title('u(k)');