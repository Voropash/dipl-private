subplot(4, 2, 1), plot(masK, masU) 
title('u(k)');

subplot(4,2,2), 
plot(masK, Poteri)
title('������� ������')

subplot(4,2,3), 
plot(masK, lll)
title('1� ���������� �����������')
%hold on
%plot(k_zero,l1_zero,'-r*')
%hold off;

subplot(4,2,4), 
plot(masK, masDiff)
title('1� ����������� ����� �������')

subplot(4,2,5), 
plot(masK, llll)
title('2� ���������� �����������')
%hold on
%plot(k_zero,l1_zero,'-r*')
%hold off;

subplot(4,2,6), 
plot(masK, masD2l_dp2)
title('2� ����������� ����� �������')


subplot(4,2,7), 
plot(masK, masLambda)
title('���. ����������� �������� ������� �����')
%hold on
%plot(k_zero,0,'-r*')
%hold off;

