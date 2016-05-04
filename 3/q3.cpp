#include <stdio.h>
#include <mpi.h>

int main (int argc, char *argv[]) 
{
	int counter, size, rank;

	double start_time, end_time, exe_time;

	MPI_Status status;
	MPI_Init (&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if (rank != 0) {
		MPI_Recv(&counter, 1, MPI_INT, rank - 1, 0, MPI_COMM_WORLD, &status);
		printf("Process %d received value %d from process %d\n", rank, counter, rank - 1);
	} 
	else 
	{
		start_time = MPI_Wtime();
		// Master sets initial value before sending.
		counter = -1;
	}

	counter += 1;

	MPI_Send(&counter, 1, MPI_INT, (rank + 1) % size, 0, MPI_COMM_WORLD);

	if (rank == 0) 
	{
		MPI_Recv(&counter, 1, MPI_INT, size - 1, 0, MPI_COMM_WORLD, &status);
		printf("Process %d received value %d from process %d\n", rank, counter, size - 1);
	
		end_time = MPI_Wtime();
		exe_time = end_time - start_time;
		printf("time taken: %f\n", exe_time);
	}
	MPI_Finalize();
}