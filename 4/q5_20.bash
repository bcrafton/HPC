#!/bin/bash                                                                                                                                                                               
#BSUB -L /bin/bash                                                                                                                                                                        
#BSUB -J brian                                                                                                                                                                   
#BSUB -q ht-10g                                                                                                                                                                           
#BSUB -o %J.out                                                                                                                                                                           
#BSUB -e %J.err                                                                                                                                                                           
#BSUB -n 20                                                                                                                                                                               
work=/home/crafton.b/matlab
cd $work
matlab -logfile /home/crafton.b/matlab/q5_20.txt -nodisplay -r "q5(10e7)"
