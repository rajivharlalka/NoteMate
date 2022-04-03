%Main Program for the solution of poisson's equation
%-laplace u=f in 2D using iteration Jacobi Method
%LSE Au=b ,s=h^2f; version III
close all
clc
clear
clf
%define input parameters
%Input parameter
n=20;a_amp=12;
f_amp=1;x_0=0.5;y_0=0.5;c_x=1;c_y=1;
h=1/(n+1);
%computing all matrices and vectors
%generate the matrix A
S=Discrete_Poisson_2D(n);
%generate cofficient a((x-1)_i,(x-2)_j)=a(i*h,j*h)
c=zeros(n,n);
for i=1:n
    for j=1:n
        c(i,j)=1+a_amp*exp(-((i*h-x_0)^2/(2*c_x^2)+(j*h-y_0)^2/(2*c_y^2)));
    end
end
%calculate the load vector f
%if if id constant,f=f_amp*ones(n^2,1);
%if f is Gaussian function
f=zeros(n^2,1);
for i=1:n
    for j=1:n
        f(n*(i-1)+j)=f_amp*exp(-((i*h-x_0)^2/(2*c_x^2)+(j*h-y_0)^2/(2*c_y^2)));
    end
end
%create diagonal matrix D from C
D=zeros(n^2,n^2);
for i=1:n
    for j=1:n
        D(j+n*(i-1),j+n*(i-1))=c(i,j);
    end
end
%compute vector on RHS
%b=D^(-1)*f given by b(i,j)=f(i,j)/a(i,j)
b=zeros(n^2,1);
for i=1:n
    for j=1:n
        b(n*(i-1)+j)=f(n*(i-1)+j)/c(i,j);
    end
end

%--------------------------------------------
%----Jacobi Version III----------------------
%--------------------------------------------

err=1;k=0;tol=10^(-9);
%initial guess
uold=zeros(n+2,n+2);
unew=uold;
%counter for the iterations
k=0;
while(err>tol)
    for i=2:(n+1)
        for j=2:(n+1)
            unew(i,j)=(uold(i-1,j)+uold(i+1,j)+uold(i,j-1)+uold(i,j+1)+h^2*b(n*(i-2)+j-1))/4.0;
        end
    end
    k=k+1;
    err=norm(unew-uold);
    uold=unew;
end
u=reshape(unew(2:end-1,2:end-1)',n*n,1);
disp('------Numbers of iteration in version III of jacobi method------')
k
figure(1)
%plot and figure for jacobi version III
%--------------------
%sort the data in u into the mesh grid the boundary conditions zero
V_new=zeros(n+2,n+2);
for i=1:n
    for j=1:n
        V_new(i+1,j+1)=u(j+n*(i-1));
    end
end
%plotting
x1=0:h:1;y1=0:h:1;
subplot(1,2,1)
surf(x1,y1,V_new)
view(2)
colorbar
xlabel('x_1')
ylabel('y_1')
zlabel('u(x_1,x_2)')
title(['Solution u(x_1,x_2) Jacobi version III',', N=',num2str(n),', iter=',num2str(k)])
subplot(1,2,2)
surf(x1,y1,V_new)%same plot
colorbar
xlabel('x_1')
ylabel('y_1')
zlabel('u(x_1,x_2)')
title(['Solution u(x_1,x_2) Jacobi version III',', N=',num2str(n),', iter=',num2str(k)])