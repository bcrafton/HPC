#!/bin/bash                                                                                                                                                                               
#BSUB -L /bin/bash                                                                                                                                                                        
#BSUB -J brian                                                                                                                                                                   
#BSUB -q ht-10g                                                                                                                                                                           
#BSUB -o %J.out                                                                                                                                                                           
#BSUB -e %J.err                                                                                                                                                                           
#BSUB -n 30                                                                                                                                                                              
work=/home/crafton.b/matlab
cd $work
matlab -logfile /home/crafton.b/matlab/q2_30.txt -nodisplay -r "q2(10e7)"
