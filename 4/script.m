configCluster('discovery');
ClusterInfo.setQueueName('ht-10g')
ClusterInfo.setProcsPerNode(16)

[dist, runtime] = q2(10 .^ 3);
disp(runtime);
[dist, runtime] = q2(10 .^ 5);
disp(runtime);
[dist, runtime] = q2(10 .^ 7);
disp(runtime);

[dist, runtime] = q3(10 .^ 3);
disp(runtime);
[dist, runtime] = q3(10 .^ 5);
disp(runtime);
[dist, runtime] = q3(10 .^ 7);
disp(runtime);

[dist, runtime] = q4(10 .^ 3);
disp(runtime);
[dist, runtime] = q4(10 .^ 5);
disp(runtime);
[dist, runtime] = q4(10 .^ 7);
disp(runtime);

[dist, runtime] = q5(10 .^ 3);
disp(runtime);
[dist, runtime] = q5(10 .^ 5);
disp(runtime);
[dist, runtime] = q5(10 .^ 7);
disp(runtime);

[dist, runtime] = q7(10 .^ 3);
disp(runtime);
[dist, runtime] = q7(10 .^ 5);
disp(runtime);
[dist, runtime] = q7(10 .^ 7);
disp(runtime);
