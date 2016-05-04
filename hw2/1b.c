#include <omp.h> // openmp header
#include <stdio.h> // use stdio.h instead of iostream
#include <stdlib.h>
#include <time.h>
#include<math.h>

#define ARRAY_SIZE 100000000

int main (int argc, char *argv[]) 
{
	double* a = (double*) malloc(sizeof(double) * ARRAY_SIZE);
	double* b = (double*) malloc(sizeof(double) * ARRAY_SIZE);
	double* sum = (double*) malloc(sizeof(double) * ARRAY_SIZE);

	if(a == NULL || b == NULL || sum == NULL)
	{
		printf("malloc failed");
		return 0;
	}

	int i;
	for(i = 0; i < ARRAY_SIZE; i++)
	{
		a[i] = (double)i;
		b[i] = (double)i;
	}

	clock_t start, end;
	double cpu_time_used;
	start = clock();

	int nthreads, tid;
	double totdist;
	double dist = 0;

	// Fork a team of threads giving them their own copies of variables 
	#pragma omp parallel private(nthreads, tid, dist)
	{ 
		// place open brace on new line so it isn't consumed by pre-processor
		tid = omp_get_thread_num();
		nthreads = omp_get_num_threads();
		
		int block_size = ARRAY_SIZE / nthreads;
		int start = tid * block_size;

		int i;
		for(i = start; i < start + block_size; i++)
		{
			sum[i] = a[i] + b[i];
			dist += pow(sum[i],2);
		}
		//printf("start: %d end: %d dist: %f\n", start, start + block_size, dist);
		#pragma omp atomic
		totdist += dist;
	}
	totdist = sqrt(totdist);

	printf("Euclidean distance between v1 and v2 is %f\n", totdist); 
	free(a);free(b);free(sum);
	
	end = clock();
	cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
	printf("time used: %f", cpu_time_used);
}