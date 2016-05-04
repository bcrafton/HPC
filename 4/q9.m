function [time_taken, distance]=q9(size)
	tic;
	a = gpuArray([1:size]);
	b = gpuArray([1+1:size+1]);
	c = gpuArray([1:size]);
	
	c = a - b;
	c = sum(c.^2);
	distance = sqrt(c)
	runtime = toc