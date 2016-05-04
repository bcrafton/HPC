function [time_taken, distance]=q4(size)
	
	a = [1:size];
	b = [1+1:size+1];
	diff = zeros(size, 1);

	parpool(10);

	tic;
	spmd
		dist = 0;
		problem_size = (size/numlabs);
		start = problem_size * (labindex-1) + 1;
		last = problem_size * (labindex);
		for i = start:last
			sum(i) = a(i) - b(i);
			dist = dist + sum(i) .^ 2;
		end
		totdist = gplus(dist);
	end
	totdist = totdist{1};
	totdist = sqrt(totdist);

	
	time_taken = toc;
	distance = totdist;

	delete(gcp);