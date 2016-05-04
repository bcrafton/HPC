function [time_taken, distance]=q5(size)
	
	a = [1:size];
	b = [1+1:size+1];
	diff = zeros(size, 1);

	parpool(10);

	tic;

	ad = distributed(a);
	bd = distributed(b);
	diffd = distributed(diff);

	diffd = ad - bd;
	dist = sum(diffd .^ 2);

	totdist = sqrt(dist);

	time_taken = toc;
	distance = totdist;

	delete(gcp);
