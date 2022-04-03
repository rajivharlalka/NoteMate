% Main program for the solution of Poisson's equation
% - laplace U = f in 2D using iterative Gauss - Seidel Method
% With Red-Black ordering Version I
%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clc
clear
clf

n=20;
a_amp=12;
f_amp=1;
x_0=0.5; y_0 = 0.5; c_x = 1; c_y=1;
h=1/(n+1);


% ----------------------------------
% Computing all matrices and vectors
% ----------------------------------

S=DiscretePoisson2D(n);

% Generate coefficient matrix of a((x_1)_i, (x_2)_j) = a(i*h, j*h)
C=zeros(n,n);
for i=1:n
    for j=1:n
        C(i,j)=1+a_amp*exp(-((i*h-x_0)^2/(2*c_x^2)+(j*h-y_0)^2/(2*c_y^2)));
    end
end

% Create diagonal matrix from c
D=zeros(n^2,n^2);
for i=1:n
    for j=1:n
        D(j+n*(i-1),j+n*(i-1)) = C(i,j);
    end
end

% If f is cons
% f = f_amp * ones(n^2, 1);

% If f is Gaussian function
f=zeros(n^2,1);
for i=1:n
    for j=1:n
        f(n*(i-1)+j) = f_amp*exp(-((i*h-x_0)^2/(2*c_x^2)+(j*h-y_0)^2/(2*c_y^2)));
    end
end

b=zeros(n^2,1);
for i =1:n
    for j=1:n
        b(n*(i-1)+j)=h^2*(f(n*(i-1)+j))/C(i,j);
    end
end




% Poisson2D_Gauss-Seidel RedBlack (VersionI)



err = 12;k=0;tol=10^(-9);
V=zeros(n,n);V_old=zeros(n,n);F=vec2mat(b,n)';
X=diag(ones(1,n-1),-1); X = X+X';
blackindex=invhilb(n)<0;
redindex=fliplr(blackindex);
B=V;
V(redindex)=0;
R=V;
V(blackindex)=0;
redF=F;
redF(blackindex)=0;
blackF=F;
blackF(redindex)=0;
while(err>tol)
    R=(X*B+B*X+h^2*redF)/4;
    B=(X*R+R*X+h^2*blackF)/4;
    k=k+1;
    V_new=R+B;
    err=norm(V_new-V_old);
    V_old=V_new;
end
V_new=[zeros(1,n+2);zeros(n,1) V_new zeros(n,1);zeros(1,n+2)];
disp('-----------Number of iterations in Gauss-Seidel method with redblack ordering----------')
k
x1=0:h:1; y1=0:h:1;
subplot(1,2,1)
surf(x1,y1,V_new)
view(2)
colorbar
xlabel('x_1')
ylabel('y_1')
zlabel('u(x_1,x_2)')
title(['Solution u(x_1,x_2) Gauss-Seidel Red-Black ordering, version I ', ...
    ', N = ', num2str(n), ', iter = ', num2str(k)])

subplot(1,2,2)
surf(x1,y1,V_new)
colorbar
xlabel('x_1')
ylabel('y_1')
zlabel('u(x_1,x_2)')
title(['Solution u(x_1,x_2) Gauss-Seidel Red-Black ordering, version I ', ...
    ', N = ', num2str(n), ', iter = ', num2str(k)])
