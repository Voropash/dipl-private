function [out] = iterformat(N)
iters = zeros(N, 1);
for i = 1:1:20
   iters(i) = 1; 
end
for i = 20:10:50
   iters(i) = 1; 
end
for i = 100:100:1000
   iters(i) = 1; 
end
for i = 1000:1000:N
   iters(i) = 1; 
end
iters = iters(1:N);
out = iters;