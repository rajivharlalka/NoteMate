% I(a) 
% Rajiv Harlalka 20MA20073

clear
clc
% Loop to generate Vandermonde Matrix
for i=1:10
    for j=1:10
        A(i,j)=(i+1)^(j-1);
    end
end
% Print Matrix A
A

% Calculate matrix L , P , U
[L,P,U]=LU__PP(A);

% Print Matrixes L , P , U
P
L
U

function [L,P,U] = LU__PP(A)
    [n,n] = size(A);
    P = eye(n);
    L = eye(n);
    U = A;
    for i=1: n-1
        [pivot, m] = max(abs(U(i:n, i)));
        m = m+i-1;
        if m~=i
            % swap rows m and i in P
            temp = P(i,:);
            P(i,:) = P(m,:);
            P(m,:) = temp;
            % swap rows m and i in P
            temp = U(i,:);
            U(i,:) = U(m,:);
            U(m,:) = temp;
            % swap rows m and i in P
                if i>=2
                    temp = L(i,1:i-1);
                    L(i,1:i-1) = L(m,1:i-1);
                    L(m,1:i-1) = temp;
                end
        end
        L(i+1:n,i) = U(i+1:n,i)/U(i,i);
        U(i+1:n, i+1:n) = U(i+1:n, i+1:n) - L(i+1:n, i)*U(i,i+1:n);
        U(i+1:n,i) = 0;
    end
end