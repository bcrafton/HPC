#include <stdio.h>
#include <stdlib.h>
#include <math.h>
 
__global__ void vector_min(float *a, int n)
{
	// each block should cover blockDim.x * 2 elements
	int thread_id = blockIdx.x * blockDim.x + threadIdx.x;
	int s;
	for(s=1; s<blockDim.x; s*=2)
	{
		if (thread_id % 2*s == 0 && thread_id * s + s < n)
		{
			if(a[thread_id * s + s] < a[thread_id * s])
			{
				a[thread_id * s] = a[thread_id * s + s];
			}
		}
		__syncthreads();
	}
}

int main( int argc, char* argv[] )
{
	cudaEvent_t start,stop;
	float elapsedTime;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	if(argc < 2)
	{
   		printf("need exactly 1 argument\n");
    		return 0;
  	}
  	int vector_size = atoi(argv[1]);
	
	float* host_a = (float*)malloc(sizeof(float)*vector_size);
	
	float* device_a;
	cudaMalloc(&device_a, sizeof(float)*vector_size);
	
	int i;
	for(i=0; i<vector_size; i++)
	{
		host_a[i] = rand() % vector_size;
	}
	
	cudaEventRecord(start,0);

	cudaMemcpy( device_a, host_a, sizeof(float)*vector_size, cudaMemcpyHostToDevice);

	int block_size = 1024;
	int num_blocks = vector_size/block_size;
	if(vector_size%block_size)
		num_blocks++;

	vector_min<<<num_blocks, block_size>>>(device_a, vector_size);
	
	cudaMemcpy( host_a, device_a, sizeof(float)*vector_size, cudaMemcpyDeviceToHost);

	for(i=0; i<vector_size; i+= block_size)
	{
		if(host_a[i] < host_a[0])
		{
			host_a[0] = host_a[i];
		}
	}

	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime,start,stop);

	printf("%f\n", elapsedTime);

	cudaFree(device_a);
	
	free(host_a);
	
	return 0;
}