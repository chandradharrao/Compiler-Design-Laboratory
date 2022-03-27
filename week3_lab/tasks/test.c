#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int main()
{
    char s[100] = "4.0800";
    printf("Double value : %lf\n",strtod(s,NULL));

    float f;
    sscanf(s,"%f",&f);

    printf("Float val %f\n",f);
    return 0;
}