#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "string.h"
#include <sys/time.h>
#include <time.h>

#define DEFAULT_THRESHOLD  4000
#define DEFAULT_FILENAME "ansel3.ppm"

unsigned int* read_ppm(char* filename, int* image_width, int* image_height, int* maxval);
void write_ppm(char* filename, int image_width, int image_height, int maxval, int* pic);
__global__ void sobel(int* input_image, int* output_image, int image_width, int image_height, int thresh);

int main( int argc, char **argv )
{
	int thresh = DEFAULT_THRESHOLD;
	char *filename;
	filename = strdup( DEFAULT_FILENAME);

	if (argc > 1) 
	{
		if (argc == 3)  
		{ // filename AND threshold
			filename = strdup( argv[1]);
			thresh = atoi( argv[2] );
		}
		if (argc == 2) 
		{ // default file but specified threshhold
			thresh = atoi( argv[1] );
		}
		fprintf(stderr, "file %s    threshold %d\n", filename, thresh);
	}


	int image_width, image_height, maxval;
	unsigned int *host_input_image = read_ppm( filename, &image_width, &image_height, &maxval );

	int numbytes =  image_width * image_height * sizeof(int);
	int *host_result = (int *) malloc(numbytes);
	if (!host_result) 
	{
		fprintf(stderr, "sobel() unable to malloc %d bytes\n", numbytes);
		exit(-1); // fail
	}
	
	int* device_input_image;
	int* device_result;
	
	cudaMalloc(&device_input_image, numbytes);
	cudaMalloc(&device_result, numbytes);	
	
	cudaMemcpy(device_input_image, host_input_image, numbytes, cudaMemcpyHostToDevice);
	
	dim3 threads_per_block(32, 32);
	dim3 blocks_per_grid(ceil(image_width/32.0), ceil(image_height/32.0));
	
	float elapsed_time;
	cudaEvent_t start_event, stop_event;
	cudaEventCreate(&start_event);
	cudaEventCreate(&stop_event);
	cudaEventRecord(start_event, 0);

	sobel<<<blocks_per_grid, threads_per_block>>>(device_input_image, device_result, image_width, image_height, thresh);
	
	cudaEventRecord(stop_event, 0);
	cudaEventSynchronize(stop_event);
	cudaEventElapsedTime(&elapsed_time, start_event, stop_event);

	cudaMemcpy(host_result, device_result, numbytes, cudaMemcpyDeviceToHost);
	
	cudaFree(device_input_image);
	cudaFree(device_result);
	
	write_ppm( "result.ppm", image_width, image_height, 255, host_result);

	printf("Elapsed time: %f milliseconds\n", elapsed_time);
	
	return 0;
}

unsigned int *read_ppm( char *filename, int * image_width, int * image_height, int *maxval ){

  if ( !filename || filename[0] == '\0') {
    fprintf(stderr, "read_ppm but no file name\n");
    return NULL;  // fail
  }

  FILE *fp;

  fprintf(stderr, "read_ppm( %s )\n", filename);
  fp = fopen( filename, "rb");
  if (!fp)
    {
      fprintf(stderr, "read_ppm()    ERROR  file '%s' cannot be opened for reading\n", filename);
      return NULL; // fail

    }

  char chars[1024];
  //int num = read(fd, chars, 1000);
  int num = fread(chars, sizeof(char), 1000, fp);

  if (chars[0] != 'P' || chars[1] != '6')
    {
      fprintf(stderr, "Texture::Texture()    ERROR  file '%s' does not start with \"P6\"  I am expecting a binary PPM file\n", filename);
      return NULL;
    }

  unsigned int width, height, maxvalue;


  char *ptr = chars+3; // P 6 newline
  if (*ptr == '#') // comment line!
    {
      ptr = 1 + strstr(ptr, "\n");
    }

  num = sscanf(ptr, "%d\n%d\n%d",  &width, &height, &maxvalue);
  fprintf(stderr, "read %d things   width %d  height %d  maxval %d\n", num, width, height, maxvalue);
  *image_width = width;
  *image_height = height;
  *maxval = maxvalue;

  unsigned int *pic = (unsigned int *)malloc( width * height * sizeof(unsigned int));
  if (!pic) {
    fprintf(stderr, "read_ppm()  unable to allocate %d x %d unsigned ints for the picture\n", width, height);
    return NULL; // fail but return
  }

  // allocate buffer to read the rest of the file into
  int bufsize =  3 * width * height * sizeof(unsigned char);
  if ((*maxval) > 255) bufsize *= 2;
  unsigned char *buf = (unsigned char *)malloc( bufsize );
  if (!buf) {
    fprintf(stderr, "read_ppm()  unable to allocate %d bytes of read buffer\n", bufsize);
    return NULL; // fail but return
  }
  
  // TODO really read
  char duh[80];
  char *line = chars;

  // find the start of the pixel data.   no doubt stupid
  sprintf(duh, "%d\0", *image_width);
  line = strstr(line, duh);
  //fprintf(stderr, "%s found at offset %d\n", duh, line-chars);
  line += strlen(duh) + 1;

  sprintf(duh, "%d\0", *image_height);
  line = strstr(line, duh);
  //fprintf(stderr, "%s found at offset %d\n", duh, line-chars);
  line += strlen(duh) + 1;

  sprintf(duh, "%d\0", *maxval);
  line = strstr(line, duh);


  fprintf(stderr, "%s found at offset %d\n", duh, line - chars);
  line += strlen(duh) + 1;

  long offset = line - chars;
  //lseek(fd, offset, SEEK_SET); // move to the correct offset
  fseek(fp, offset, SEEK_SET); // move to the correct offset
  //long numread = read(fd, buf, bufsize);
  long numread = fread(buf, sizeof(char), bufsize, fp);
  fprintf(stderr, "Texture %s   read %ld of %ld bytes\n", filename, numread, bufsize);

  fclose(fp);


  int pixels = (*image_width) * (*image_height);
  int i;
  for (i=0; i<pixels; i++) pic[i] = (int) buf[3*i];  // red channel

  return pic; // success
}

void write_ppm( char *filename, int image_width, int image_height, int maxval, int *pic)
{
  FILE *fp;

  fp = fopen(filename, "w");
  if (!fp)
    {
      fprintf(stderr, "FAILED TO OPEN FILE '%s' for writing\n");
      exit(-1);
    }

  fprintf(fp, "P6\n");
  fprintf(fp,"%d %d\n%d\n", image_width, image_height, maxval);

  int numpix = image_width * image_height;
  int i;
  for (i=0; i<numpix; i++) {
    unsigned char uc = (unsigned char) pic[i];
    fprintf(fp, "%c%c%c", uc, uc, uc);
  }
  fclose(fp);

}

__global__ void sobel(int* input_image, int* output_image, int image_width, int image_height, int thresh)
{	
	int j = blockIdx.x * blockDim.x + threadIdx.x + 1;
	int i = blockIdx.y * blockDim.y + threadIdx.y + 1;

	if( (i < (image_height-1)) && (j < (image_width-1)) )
	{
		int sum1, sum2, magnitude;
	
		int offset = i*image_width + j;

		sum1 =  input_image[ image_width * (i-1) + j+1 ] -     input_image[ image_width*(i-1) + j-1 ]
		+ 2 * input_image[ image_width * (i)   + j+1 ] - 2 * input_image[ image_width*(i)   + j-1 ]
		+     input_image[ image_width * (i+1) + j+1 ] -     input_image[ image_width*(i+1) + j-1 ];

		sum2 = input_image[ image_width * (i-1) + j-1 ] + 2 * input_image[ image_width * (i-1) + j ]  + input_image[ image_width * (i-1) + j+1 ]
		- input_image[image_width * (i+1) + j-1 ] - 2 * input_image[ image_width * (i+1) + j ] - input_image[ image_width * (i+1) + j+1 ];

		magnitude =  sum1*sum1 + sum2*sum2;

		if (magnitude > thresh)
			output_image[offset] = 255;
		else
			output_image[offset] = 0;
	}
}
