#include <omp.h> // openmp header
#include <stdio.h> // use stdio.h instead of iostream
#include <stdlib.h>
#include <time.h>
#include<math.h>

#define ARRAY_SIZE 10000

int main (int argc, char *argv[]) 
{
	/*
	int nthreads, tid;
	
	// Fork a team of threads giving them their own copies of variables 
	#pragma omp parallel private(nthreads, tid)
	{ 
		// place open brace on new line so it isn't consumed by pre-processor
		tid = omp_get_thread_num();
		if (tid == 0){ // only master thread prints this
			nthreads = omp_get_num_threads();
			printf("Number of threads = %d\n",nthreads);
		} 
		else{
		printf("Hello World from thread = %d\n",tid); }
	}
	*/

	clock_t start, end;
	double cpu_time_used;
	start = clock();
	
	int* a = (int*) malloc(sizeof(int) * ARRAY_SIZE);
	int* b = (int*) malloc(sizeof(int) * ARRAY_SIZE);
	int* sum = (int*) malloc(sizeof(int) * ARRAY_SIZE);
	
	if(a == NULL || b == NULL || sum == NULL)
	{
		printf("malloc failed");
		return 0;
	}

	int i;
	for(i = 0; i < ARRAY_SIZE; i++)
	{
		a[i] = i;
		b[i] = i;
	}

	int dist = 0;
	#pragma omp parallel for
	for(i=0; i<ARRAY_SIZE; i++)
	{
		sum[i] = a[i] + b[i];
		dist += pow(sum[i],2);
			
	}
	dist = sqrt(dist);
	printf("Euclidean distance between v1 and v2 is %f\n",dist); 
	free(a);free(b);free(sum);
	
	end = clock();
	cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
	printf("time used: %f", cpu_time_used);
}