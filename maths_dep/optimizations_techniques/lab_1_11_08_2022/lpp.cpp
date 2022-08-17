#include<bits/stdc++.h>
using namespace std;

double z=0;

vector<double> gauss(vector< vector<double> > A) 
{
    int n = A.size();
    int i,j,k,flag=0;
    int count=0;
    double y;
    vector<double> x(n,0.0);

    do
    {
        if(count>1000)
            break;
        for (i=0;i<n;i++)                
        {
            y=x[i];
            x[i]=A[i][n];
            for (j=0;j<n;j++)
            {
                if (j!=i)
                x[i]=x[i]-A[i][j]*x[j];
            }
            x[i]=x[i]/A[i][i];
            if (abs(x[i]-y)<=0.000001)           
                flag++;
        }
        count++;   
    }while(flag<n);     

    return x;
}

void print(vector< vector<double> > A) {
    int n = A.size();
    for (int i=0; i<n; i++) {
        for (int j=0; j<n+1; j++) {
            cout << A[i][j] << "      ";
            if (j == n-1) {
                cout << "| ";
            } 
        }
        cout << "\n";
    }
    cout << endl;
}

void evaluate(vector<int> permut,vector<vector<double> > matrix, int n , int r,vector<int> lpp)
{ 
	vector<vector<double> > A(r,vector<double>(r+1,0));

    cout<<"Variables which are zero in this Iteration\n";
	for (int i=0; i<n; i++) 
	{
		if(permut[i]==0)
            cout<<"x"<<i+1<<" ";
	}

    cout<<endl;

    int key=0;

    for(int i=0;i<r;i++)
    {
        key=0;
        for(int j=0;j<n;j++)
        {
            if(permut[j]==1)
            {
                A[i][key]=matrix[i][j];
                key++;
            }
        }
        A[i][r]=matrix[i][n];
    }
	
    cout<<"The augmented matrix is\n";
    print(A);
	vector<double> x(r);
	x = gauss(A);
	cout<<"The values of the non-zero variables are\n";
	for (int i=0; i<r; i++) 
	{
		cout << x[i] << " ";
	}
    key=0;
    cout<<endl<<"( ";
    for(int i=0;i<n;i++)
    {
        if(permut[i]==0)
        {
            cout<<0;
        }
        else
        {
            cout<<x[key];
            key++;
        }
        if(i<n-1)
        cout<<", ";

    }
    cout<<")"<<endl;
	for (int i=0; i<r; i++) 
	{
		if(x[i]<0)
		{
			cout<<"This is not the Basic Feasible Solution\n\n";
            cout<<"--------------------------------------------------------------------\n\n";
			return;		
		}
	}
    double val=0;
    int p=0;
	for(int i=0;i<n;i++)
    {
       
        if(permut[i]==1)
        {
            val+=lpp[i]*x[p];
            p++;
        }
        

    }
    cout<<"Value of lpp in this iteration is: "<<val<<endl;
    z=max(z,val);
	
	cout << endl;
	cout<<"--------------------------------------------------------------------\n\n";

}

void generatePermutation(int n, int r,vector<vector<double> > matrix,vector<int> lpp)
{
    vector<int> permut(n);
    for(int i=0;i<n;i++)
    {
        
        if(i<n-r)
        permut[i]=0;
        else
        permut[i]=1;
    }

    do {
        evaluate(permut,matrix,n,r,lpp);
    } while (next_permutation(permut.begin(), permut.end()));
}

int main()
{
    
	int r,n;	
	cout<<"Input the number of Unknowns: ";
	cin>>n;
	cout<<"Input the number of Equations: ";
	cin>>r;
    cout<<"Enter the coefficient of equations along with the right side value\n";
    vector<vector<double> > matrix(r,vector<double>(n+1,0));
    for(int i=0;i<r;i++)
    {
        for(int j=0;j<n+1;j++)
            cin>>matrix[i][j];
    }

    vector<int> lpp(n,0);
    cout<<"Enter the lpp that needs to be solved: \n";
    for(int i=0;i<n;i++)
    {
        cin>>lpp[i];
    }

    cout<<endl;
 
    generatePermutation( n, r,matrix,lpp);

    cout<<"The solution for the lpp is: "<<z<<endl;
}

