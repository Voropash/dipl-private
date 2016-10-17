subplot(5, 2, 1), plot(masK, masU) 
title('u(k)');

subplot(5,2,2), 
plot(masK, Poteri)
title('функция потерь')

subplot(5,2,3), 
plot(masK, lll)
title('1я разностная производная')
%hold on
%plot(k_zero,l1_zero,'-r*')
%hold off;

subplot(5,2,4), 
plot(masK, masDiff)
title('1я производная через якобиан')

subplot(5,2,5), 
plot(masK, lll_i)
title('1я разностная производная (i)')
%hold on
%plot(k_zero,l1_zero,'-r*')
%hold off;

subplot(5,2,6), 
plot(masK, masDiffI)
title('1я производная через якобиан (i)')

subplot(5,2,7), 
plot(masK, llll)
title('2я разностная производная')
%hold on
%plot(k_zero,l1_zero,'-r*')
%hold off;

subplot(5,2,8), 
plot(masK, masD2l_dp2)
title('2я производная через якобиан')


subplot(5,2,9), 
plot(masK, masLambda)
title('мин. собственное значение матрицы гессе')
%hold on
%plot(k_zero,0,'-r*')
%hold off;

