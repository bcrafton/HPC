function [time_taken, distance]=q2(size)
	
	a = [1:size];
	b = [1+1:size+1];

	tic;

	diff = a - b;
	dist = diff .^ 2;
	dist = sum(dist); 
	dist = sqrt(dist);
	
	time_taken = toc;
	
	distance = dist;
    