masU = [];
masLambda = [];
masD2l_dp2=[];
masDiff = [];
masDiffI = [];
masHessFromMatlabFunction = [];
masK = [];
masL=[];
masUmin = [];
lll=[];
llll=[];
lll_i=[];
Poteri = [];
S = S_Base;
l=0;
l3_res = 0;
l1_res = 0;

step = 0.1;
for k = step:step:7
    k
    S = S_Base * k;
    perform;
    l_delta = l;
    if (flagNotSeries~=true)
            masK = [masK, k];
            masLambda = [masLambda, real(uuu)];
            masHessFromMatlabFunction = [masHessFromMatlabFunction, lost_function( u,v, G,B )];
      
            masU = [masU, u(2)];
            masL = [masL, l];
            masD2l_dp2 = [masD2l_dp2,d2l_dp2];
            sizel = length(masLambda);
            if sizel > 2 && masLambda(sizel-1)>0 && uuu<0
                k_zero = k;
            end
            l_s_1 = l_s(1);
            m1 = lost_function(u,v,G,B);
            S = S_Base * k + [0.001;zeros(DIM-1,1)];
            perform;
            m2 = lost_function(u,v,G,B);
            manual = ((m2 - m1)/0.001);
            masDiff = [masDiff, l_s_1];
            masDiffI = [masDiffI,manual];
            disp('-------------')            
    else
        disp(S);
        break;
    end
end;


subplot(2, 1, 1), 
plot(masK, masU) 
title('12');

subplot(2,1,2), 
plot(masK, masLambda)
title('������� ������')
