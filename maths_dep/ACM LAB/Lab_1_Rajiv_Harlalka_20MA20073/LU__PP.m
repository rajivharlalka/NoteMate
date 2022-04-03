% Code for the algorithm 1
%LU Factorisation; GEPP Constructing, P,L,U such that PA = LU
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
            temp = P(i,:);
            P(i,:) = P(m,:);
            P(m,:) = temp;
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