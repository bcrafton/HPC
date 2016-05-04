#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include "mpi.h"


main(int argc, char **argv ) 
{
	char message[20];
	strcpy(message, "Hello, world");
	int i,rank, size, type=99;
	const int root = 0;

	double start_time, end_time, exe_time;
	
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);

	if(rank == 0)
	{
		start_time = MPI_Wtime();	
	}

	MPI_Bcast(message, 13, MPI_CHAR, root, MPI_COMM_WORLD);
	
	MPI_Barrier(MPI_COMM_WORLD);

	if(rank == 0) 
	{
		end_time = MPI_Wtime();
		exe_time = end_time - start_time;
		printf("time taken: %f\n", exe_time);

	}
	
	printf( "Message from process =%d : %.13s\n", rank, message);
	MPI_Finalize();
}