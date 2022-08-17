/* NAME= Rajiv Harlalka
    Roll no. = 20MA20073
    LAB - 2 17/08/2022 */
    
#include<bits/stdc++.h>
using namespace std;

void makeTable(vector<vector<int>> A,vector<int> B,vector<double> expression,int rows,int columns,vector<vector<double>> &table)
{
    int n=columns-rows-1;

    for(int i=0;i<n;i++)
    {
        table[rows-1][2+i]=expression[i];
    }

    for(int i=1;i<rows-1;i++)
        table[i][0]=n+i;
    
    for(int i=2;i<columns-1;i++)
        table[0][i]=i-1;

    for(int i=1;i<rows-1;i++)
    {
        for(int j=2;j<columns-1;j++)
        {
            table[i][j] = A[i-1][j-2];
        }
        table[i][columns-1] = B[i-1];
    }

    cout<<"\n";
}

int main()
{
    int n,m;
    cout<<"Enter the number of variables\n";
    cin>>n;
    cout<<"Enter the number of equations"<<endl;
    cin>>m;

    vector<vector<int> > A(m,vector<int>(n+m,0));

    vector<int> B(m,0);
    cout<<"Enter the co-efficients of the equations:\n";
    for(int i=0;i<m;i++)
    {
        for(int j=0;j<n;j++)
            cin>>A[i][j];
    }

    cout<<"Enter the right side values of the equations\n";
    for(int i=0;i<m;i++)
        cin>>B[i];

    cout<<"Enter the co-efficients of the matrix that needs to be maximised\n";
    vector<double> expression(n,0);
     for(int i=0;i<m;i++)
    {
        cin>>expression[i];
        expression[i]=-1*expression[i];
    }


    for(int i=0;i<m;i++)
    {
        for(int j=n;j<n+m;j++)
            A[i][j]=0;
        A[i][i+n]=1;
    }

    vector<vector<double>> table(m+2,vector<double>(n+m+3,0));

    makeTable(A,B,expression,m+2,n+m+3,table);


    for(auto it:table)
    {
        for(auto itr:it)
        {
            cout<<itr<<" ";
        }
        cout<<endl;
    }
    return 0;
}