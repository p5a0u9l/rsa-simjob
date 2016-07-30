#!/usr/local/bin/julia

#= In number theory, Euler's totient function (or Euler's phi function), denoted as φ(n) or ϕ(n), is an arithmetic function that counts the positive integers less than or equal to n that are relatively prime to n. (These integers are sometimes referred to as totatives of n.) Thus, if n is a positive integer, then φ(n) is the number of integers k in the range 1 ≤ k ≤ n for which the greatest common divisor gcd(n, k) = 1. =# 

# The RSA cryptosystem 
# Setting up an RSA system involves choosing large prime numbers p and q, 
# computing n = pq and k = φ(n), and finding two numbers e and d such that ed ≡ 1 
# (mod k). 
# The numbers n and e (the "encryption key") are released to the public, and d 
# (the "decryption key") is kept private. 

# A message, represented by an integer m, where 0 < m < n, is encrypted by 
# computing S = me (mod n). 

# It is decrypted by computing t = Sd (mod n). Euler's Theorem can be used to 
# show # that if 0 < t < n, then t = m. 

# The security of an RSA system would be compromised if the number n could be 
# factored or if φ(n) could be computed without factoring n. 

# brute force solution 
function totient_brute(n)
    if isprime(n)
        return n - 1;
    else
        c = 0;
        for k = 1:n - 1
            if gcd(k, n) == 1
                c += 1;
            end
        end
        return c
    end
end
 
# closed form - faster, euler's formula 
function totient(n)
    P = 1;
    for p in keys(factor(n))
        if isprime(p)
            P *= (1 - 1/p);     
        end
    end
    return round(Int64, P*n)
end

function example()
    N = 1000000; 
    #= c = [totient(n) for n in 1:N]; =#
    d = [phi(n) for n in 1:N]; 
    d = round(Int64, d); 
    using PyPlot
    #= plot(d, ".r", markersize=1) =#
    h = hist(d, 1000);
    plot(h[2])
end
 
 
