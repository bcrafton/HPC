#include <omp.h> // openmp header
#include <stdio.h> // use stdio.h instead of iostream
int main (int argc, char *argv[]) 
{
	int nthreads, tid;
	
	/* Fork a team of threads giving them their own copies of variables */
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
	/* All threads join master thread and disband */ 
}