function [time_taken, distance]=q3(size)
	
	a = [1:size];
	b = [1+1:size+1];
	diff = zeros(size, 1);
	dist = 0;

	parpool(10);
	
	tic;
	parfor i = 1:size
		diff(i) = a(i) - b(i);
		dist = dist + diff(i) .^ 2;
	end
	dist = sqrt(dist);

	time_taken = toc;
	distance = dist;

	delete(gcp);