% set random number generator
rng(13, 'v5uniform');

[fp, msg] = fopen('matV4.bin', 'w');
if fp == -1
    error(msg)
end
N = 2^20;

for i = 1:500
    fprintf('iteration: %d\n', i)
    x = randi(2^32-1, N, 1);
    fwrite(fp, x, 'uint32');
end
fclose(fp);
