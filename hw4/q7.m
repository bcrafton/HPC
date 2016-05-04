function [time_taken, distance]=q7(size)
	a = [1:size];
	b = [1+1:size+1];
	diff = zeros(size, 1);
	
	parpool(4);

	tic;
	spmd
		switch labindex
		case 1
			diff = a - b;
			labSend(diff, 2);
			diff = labReceive(4);
		case 2
			diff = labReceive(1);
			diff = diff .^ 2;
			labSend(diff, 3);
		case 3
			diff = labReceive(2);
			diff = sum(diff);
			labSend(diff, 4);
		case 4
			diff = labReceive(3);
			diff = sqrt(diff);
			labSend(diff, 1);
		end
	end
	totdist = diff{1};

	time_taken = toc;	
	distance = totdist;
	
	delete(gcp);