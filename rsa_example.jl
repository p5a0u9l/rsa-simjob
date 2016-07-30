#!/usr/local/bin/julia
 
 
#= Here is an example of RSA encryption and decryption. The parameters used here are artificially small, but one can also use OpenSSL to generate and examine a real keypair. =#

#= Choose two distinct prime numbers, such as =#
#= p = 61 and q = 53 =#
#= Compute n = pq giving =#
#= n = 61\times 53 = 3233 =#
#= Compute the totient of the product as φ(n) = (p − 1)(q − 1) giving =#
#= \phi (3233) = (61 - 1)(53 - 1) = 3120 =#
#= Choose any number 1 < d < 3120 that is coprime to 3120. Choosing a prime number for d leaves us only to check that d is not a divisor of 3120. =#
#= Let d = 2753 =#
#= Compute e, the modular multiplicative inverse of d (mod φ(n)) yielding, =#
#= e = 17 =#
#= Worked example for the modular multiplicative inverse: =#
#= d \times e \; \operatorname{mod}\; \varphi(n) = 1 =#
#= 2753 \times 17  \; \operatorname{mod}\; 3120 = 1 =#   

include("totient.jl");
include("ext_euclid.jl");
include("util.jl"); 

 
p, q = 101, 113; 
n = p*q;
phi = totient(n);
d = 3533;
_, e, _ = ext_euclid(d, phi);
 
m = "Such a talented Country artist.\nThis is my secret message.\nThere are many messages like it, but this one is mine";

 
e_K(x) = mod(BigInt(x)^e, n);
d_K(y) = mod(BigInt(y)^d, n);

msg_num = [Int(M[1]) for M in m];
cipher = [e_K(x) for x in msg_num];
ciphertext = [num2abc(x) for x in cipher];
plain = [d_K(y) for y in cipher];
plaintext = [Char(p) for p in plain];

println("Choose two distinct primes - p: $p, q: $q")
println("Their product: n = pq: $(p*q)")
println("Choose secret key d: $d")
println("Compute public key e: $e")
println()
 
println("the ciphertext is:\n\t$ciphertext");
println()
println("the decrypted plaintext is:\n\t$(join(plaintext))");
println()
 
 
 
