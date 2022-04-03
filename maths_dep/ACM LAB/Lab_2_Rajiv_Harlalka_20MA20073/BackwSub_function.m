function x = BackwSub(U,b)
s = size(U);
n = s(1);
x = zeros(n,1);
x(n) = b(n)/U(n,n);
for i=n-1:-1:1
    x(i) = (b(i) - U(i,(i+1):n)*x((i+1):n))/U(i,i);
end
end
