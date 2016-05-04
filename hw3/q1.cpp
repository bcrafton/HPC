#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include "mpi.h"


main(int argc, char **argv ) 
{
	char message[20];
	strcpy(message, "Hello, world");
	int i,rank, size, type=99;

	double start_time, end_time, exe_time;
	
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	
	if(rank == 0) 
	{
		start_time = MPI_Wtime();
		for (i=1; i<size; i++)
		{
			MPI_Send(message,13,MPI_CHAR,i,type, MPI_COMM_WORLD);
		}
	} 
	else
	{
		MPI_Recv(message,20,MPI_CHAR,0,type,MPI_COMM_WORLD,&status);
	}
	MPI_Barrier(MPI_COMM_WORLD);

	if(rank == 0) 
	{
		end_time = MPI_Wtime();
		exe_time = end_time - start_time;
		printf("time taken: %f\n", exe_time);

	}

	printf( "Message from process =%d : %.13s\n", rank,message);
	MPI_Finalize();
}