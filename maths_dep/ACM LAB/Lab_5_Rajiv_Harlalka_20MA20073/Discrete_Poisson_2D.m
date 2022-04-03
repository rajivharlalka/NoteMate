function A = Discrete_Poisson_2D(n)
%construct A for 2D discretization of laplace operator
%input parameter n ,number of inner nodes  same in both directions
A = zeros(n*n , n*n);
% main diagonal
for i= 1: n*n
 A(i,i) = 4 ;
end
% 1st and 2 nd off_diagonals
for k=1:n % go through blocks 1 to n
    for i = 1:(n-1)
        A(n*(k-1) +i , n*(k-1) +i +1 ) = -1;
        A(n*(k-1) +i+1 , n*(k-1) + i ) = -1;
    end
end
% 3rd and 4th off_diagonals
for i= 1:n*(n-1)
    A(i,i+n)= -1 ;
    A(i+n,i)= -1 ;
    
end
end
