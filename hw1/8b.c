/*
Compile: gcc Ecludian_dist.c -o Ecludian_dist -lm
Run: ./Euclidean_dist
*/
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include "util.h"
#include <time.h>

bool verify_subtraction(int vector_length, float* v1, float* v2, float* result);

int main(int argc,char **argv)
{
clock_t start, end;
double cpu_time_used;
start = clock();

int vector_length = parse_args(argc, argv);

printf("num args: %d vector length: %d\n", argc,  vector_length);

float *v1 = (float*)malloc(sizeof(float) * vector_length);
float *v2 = (float*)malloc(sizeof(float) * vector_length);
float *a = (float*)malloc(sizeof(float) * vector_length);

if(a == NULL || v1 == NULL || v2 == NULL)
{
	printf("malloc failed\n");
	free(a);
	free(v1);
	free(v2);
	return 0;
}

int i;
float dist;

init_vects(vector_length, v1, v2);

for (i=0; i<vector_length; i++)
{
	a[i] = v1[i] - v2[i];
	dist += pow(a[i],2);
}           
dist = sqrt(dist);  

printf("Euclidean distance between v1 and v2 is %f\n",dist);  

bool success = verify_subtraction(vector_length, v1, v2, a);
if(success)
{
	printf("success\n");
}	
else
{
	printf("failure\n");
}

free(a);
free(v1);
free(v2);

end = clock();
cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

printf("time used: %f", cpu_time_used);

return 0;
}

bool verify_subtraction(int vector_length, float* v1, float* v2, float* result)
{
	int i;
	int tmp;
	for(i=0; i<vector_length; i++)
	{
		tmp = v1[i] - v2[i];
		if(tmp != result[i])
		{
			return false;
		}
	}
	return true;
}
