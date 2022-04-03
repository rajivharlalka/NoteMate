% Question 2
% Rajiv Harlalka 20MA20073

close all
clc 
clear
clf

% Define input parameters 
n=19;% no of inner nodes

% Data-1
A=4;
k=2;
l=0.0005;
c=0.00001;

f_amp=k/(A^2);

x_0=0;y_0=0;

h=1/(n+1);% define step length

%%--------------------------------
%computing all matrices and vectors
%-----------------------------
%Generate a n*n stiffness matrices

S=DiscretePoisson2D(n);

% if f is const
% f=f_amp*ones(n^2,1)
%if f is gaussian function

f=zeros(n^2,1);
for i=1:n
    for j=1:n
        f(n*(i-1)+j)=f_amp*abs((1-exp((-1)*A*(((i*h-x_0+l)^2+(2*j*h-y_0)^2)^(1/2)-c)))^2+(1-exp((-1)*A*(((i*h-x_0-l)^2+(2*j*h-y_0)^2)^(1/2)-c)))^2);
    end
end

% compute vector of right hand side 
% b= D^(-1)*f computed as b(i,j)=f(i,j)/a(i,j)

b=zeros(n^2,1);
for i=1:n
    for j=1:n
        b(n*(i-1)+j)=h^2*(f(n*(i-1)+j));
    end
end

%%------------------------------
%Solution of S*u=b using iteration Gauss Seidel method without red-black
%ordering 

residual=1;k=0;tol=10^(-9);
u=zeros(n^2,1);
u_old=u;

%values of u(1:j-1) are already updated and u_old((j+1):n^2) are older,
%computed on the previous iteration

while(norm(residual)>tol)
    for j=1:n^2
         u(j) = 1/S(j,j)*(b(j)-S(j,1:(j-1))*u(1:(j-1))-S(j,(j+1):n^2)*u_old((j+1):n^2));
    end
    u_old=u;
    residual=S*u-b;
    k=k+1;
end
disp('----Number of iteration in Gauss-Seidel method without red-black ordering--')
k

%%----------------------------
% Plots and figures
%-----------------------------
%Sort the data in u into the mesh-grid, the boundary nodes are zeros

z=zeros(n+2,n+2);
for i=1:n
    for j=1:n
        z(i+1,j+1)=u(j+n*(i-1));
    end
end
%plotting 
x1 = 0:h:1;
y1 = 0:2*h:2;
figure(1)
subplot(1, 2, 1)
surf(x1, y1, z) % 3D plot of solution
view(2)
colorbar
xlabel('x_1')
ylabel('x_2')
zlabel('u(x_1,x_2)')
title(['Solution through Gauss-Seidel without red-black ordering', ',N = ', num2str(n), ', number of iterations = ', num2str(k)])
subplot(1, 2, 2)
surf(x1, y1, z) % 3D plot of solution
colorbar
xlabel('x_1')
ylabel('x_2')
zlabel('u(x_1,x_2)')
title(['Solution through Gauss-Seidel without red-black ordering', ',N = ', num2str(n), ', number of iterations = ', num2str(k)])