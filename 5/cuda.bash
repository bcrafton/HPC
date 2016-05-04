#!/bin/sh

#BSUB -J brian_cuda
#BSUB -o output
#BSUB -e error
#BSUB -n 1
#BSUB -q par-gpu
#BSUB cwd /home/crafton.b/cuda/
cd /home/crafton.b/cuda/

rm output
rm error

nvcc -o a vector_add.cu
./a 10000

./a 1000000

./a 100000000

./a 4096

./a 262,144

./a 16,777,216

nvcc -o a vector_min.cu
./a 10000

./a 1000000

./a 100000000

./a 4096

./a 262,144

./a 16,777,216