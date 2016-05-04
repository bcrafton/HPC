#!/bin/bash                                                                                                                                                                               
#BSUB -L /bin/bash                                                                                                                                                                        
#BSUB -J brian                                                                                                                                                                   
#BSUB -q ht-10g                                                                                                                                                                           
#BSUB -o %J.out                                                                                                                                                                           
#BSUB -e %J.err                                                                                                                                                                           
#BSUB -n 10                                                                                                                                                                               
work=/home/crafton.b/matlab
cd $work
matlab -logfile /home/crafton.b/matlab/q3_10.txt -nodisplay -r "q3(10e7)"
