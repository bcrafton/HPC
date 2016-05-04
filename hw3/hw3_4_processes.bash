#!/bin/sh
#BSUB -J Brian-Hello
#BSUB -o output4
#BSUB -e error
#BSUB -n 4
#BSUB -R "span[ptile=5]"
#BSUB -q ht-10g
#BSUB cwd /home/crafton.b/hello_world_mpi/
cd /home/crafton.b/hello_world_mpi/

rm error
rm hello_mpi
rm output4

tempfile1=hostlistrun
tempfile2=hostlist-tcp
echo $LSB_MCPU_HOSTS > $tempfile1
declare -a hosts
read -a hosts < ${tempfile1}
for ((i=0; i<${#hosts[@]}; i += 2)) ;
 do
 HOST=${hosts[$i]}
 CORE=${hosts[(($i+1))]}
 echo $HOST:$CORE >> $tempfile2
done

mpiCC -o hello_mpi q4.cpp
mpirun -np 4 -prot -TCP -lsf ./hello_mpi 10000000

mpiCC -o hello_mpi q4.cpp
mpirun -np 4 -prot -TCP -lsf ./hello_mpi 100000000

mpiCC -o hello_mpi q4.cpp
mpirun -np 4 -prot -TCP -lsf ./hello_mpi 1000000000