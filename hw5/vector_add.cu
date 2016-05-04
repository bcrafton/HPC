#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__ void vector_add(float *a, float *b, float *c, int n)
{
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	
	if(tid < n)
		c[tid] = a[tid] + b[tid];
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
	
	float* host_a = (float*)malloc(sizeof(float) * vector_size);
	float* host_b = (float*)malloc(sizeof(float) * vector_size);
	float* host_c = (float*)malloc(sizeof(float) * vector_size);
	
	float* device_a;
	float* device_b;
	float* device_c;
	cudaMalloc(&device_a, sizeof(float)*vector_size);
	cudaMalloc(&device_b, sizeof(float)*vector_size);
	cudaMalloc(&device_c, sizeof(float)*vector_size);
	
	int i;
	for(i=0; i<vector_size; i++)
	{
		host_a[i] = 1;
		host_b[i] = 1;
		//host_a[i] = rand() % vector_size;
		//host_b[i] = rand() % vector_size;
	}

	cudaEventRecord(start,0);
	
	cudaMemcpy( device_a, host_a, sizeof(float)*vector_size, cudaMemcpyHostToDevice);
	cudaMemcpy( device_b, host_a, sizeof(float)*vector_size, cudaMemcpyHostToDevice);
	
	int block_size = 1024;
	int grid_size = vector_size / block_size;
	if(vector_size % block_size)
	{
		grid_size = grid_size + 1;
	}

	vector_add<<<grid_size, block_size>>>(device_a, device_b, device_c, vector_size);
	
	cudaMemcpy( host_c, device_c, sizeof(float)*vector_size, cudaMemcpyDeviceToHost);

	float sum = 0;
	for(i=0; i<vector_size; i++)
	{
		sum += host_c[i];
	}

	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime,start,stop);

	printf("%f\n", elapsedTime);

	cudaFree(device_a);
	cudaFree(device_b);
	cudaFree(device_c);
	
	free(host_a);
	free(host_b);
	free(host_c);
	
	return 0;
}