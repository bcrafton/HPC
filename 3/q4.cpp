#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "mpi.h"


main(int argc, char **argv) 
{
	if(argc < 2){
   		printf("Only want one argument (not including num args) got %d\n", argc);
    		return 0;
  	}
  	int vector_length = atoi(argv[1]);

	int rank;
	int size;
	int i;
	
	double* global_v1;
	double* global_v2;
	double* global_dif;
	double* local_v1;
	double* local_v2;
	double* local_dif;
	double dist;
	double totdist;

	double start_time, end_time, exe_time;

	unsigned int problem_size = vector_length;
	
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	local_v1 = (double*)malloc(sizeof(double) * (problem_size / size));
	local_v2 = (double*)malloc(sizeof(double) * (problem_size / size));
	local_dif = (double*)malloc(sizeof(double) * (problem_size / size));
	if(local_v1 == NULL || local_v2 == NULL || local_dif == NULL)
	{  
		printf("process: %d malloc failed", rank);  
		return 1;
	}

	if(rank == 0) 
	{	
		
		global_v1 = (double*)malloc(sizeof(double) * problem_size);
		global_v2 = (double*)malloc(sizeof(double) * problem_size);
		global_dif = (double*)malloc(sizeof(double) * problem_size);
		if(global_v1 == NULL || global_v2 == NULL || global_dif == NULL)
		{
			printf("malloc failed from thread %d", rank);
			return 1;  
		}

		// set the array
		for (i=0; i<problem_size; i++)
		{
			global_v1[i] = (double)i;
			global_v2[i] = (double)i+1;
		}
	}

	start_time = MPI_Wtime();

	MPI_Scatter(global_v1, problem_size / size, MPI_DOUBLE, local_v1, problem_size / size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
	MPI_Scatter(global_v2, problem_size / size, MPI_DOUBLE, local_v2, problem_size / size, MPI_DOUBLE, 0, MPI_COMM_WORLD);

	// calculate partial pair
	for(i = 0; i < problem_size / size; i++)
	{
		local_dif[i] = local_v1[i] - local_v2[i];
		dist += pow(local_dif[i], 2);
	}

	MPI_Reduce(&dist, &totdist, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
	
	end_time = MPI_Wtime();

	if(rank == 0)
	{
		exe_time = end_time - start_time;
		totdist = sqrt(totdist);
		printf("problem size: %d dist: %f time taken %f\n", problem_size, totdist, exe_time);
	}

	MPI_Finalize();
}