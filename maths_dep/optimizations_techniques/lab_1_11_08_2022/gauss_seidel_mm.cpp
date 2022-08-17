#include<bits/stdc++.h>
using namespace std;

int main()
{
    int n;
    cin>>n;

    double matrix[n][n+1];
    for(int i=0;i<n;i++)
        for(int j=0;j<n+1;j++)
            cin>>matrix[i][j];


    double initial[n];
    for(int i=0;i<n;i++)
        cin>>initial[i];

    int flag=0,y,count=0;
    do
    {
        for (int i=0;i<n;i++)
        {
            y=initial[i];
            initial[i]=matrix[i][n];
            for (int j=0;j<n;j++)
            {
                if (j!=i)
                initial[i]=initial[i]-matrix[i][j]*initial[j];
            }
            initial[i]=initial[i]/matrix[i][i];
            if (fabs(initial[i]-y)<=0.0001)
                flag++;
        }
        cout<<"\n";
        count++;
    }while(flag<n);

    cout<<"\n The solution is as follows:\n";
    for (int i=0;i<n;i++)
        cout<<"x"<<i+1<<" = "<<initial[i]<<endl;
    return 0;
}
