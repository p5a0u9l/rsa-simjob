#!/usr/local/bin/julia
# psuedo-random number generator which fails spectral test badly
# https://en.wikipedia.org/wiki/RANDU

function randu(N)
    V = zeros(Int32, N, 1)
    V[1] = 13
    for n = 2:N
        V[n] = 65539*V[n-1]%2^31 
    end
    V
end

# plot
N = 300000;
x = randu(N); # PRNG stream
println("numbers generated");

doplot = true 
dowrite = false 

if doplot 
    using PyPlot;
    x = reshape(x, 3, round(Int, N/3))';
    f = figure(figsize=(7, 5));
    plot3D(x[:, 1], x[:, 2], x[:, 3], ".b", markersize=2);
    ax = Axes3D(f); 
    savefig("figures/randu_good.png")
    #= X = 20*log10(abs(fftshift(fft(x[:, 1])))); =#
    #= plot(1:length(X), X, ".-b") =#
end 

if dowrite
    f = open("randu_out.bin", "w");
    for num in x
        write(f, hex2bytes(num2hex(num)));
    end
    close(f)     
    println("string cat'd");
end

