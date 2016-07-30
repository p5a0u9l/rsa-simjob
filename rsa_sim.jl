#!/usr/local/bin/julia
using DataFrames
include("my_crypto.jl"); 

# Params
pubkey = BigInt(1073741827);
n_bit_modulus = 30;
n_msg_str = 10;
resim_msgs = true;
do_fast = true;
do_crack = true;
N =  10000^2; #number of sim'd messages
rng_type = set_rng_type("randu");
#= cache_file = ".$(rng_type)_$(N)_msgs_$(n_bit_modulus)_bits.csv"; =# 

function message_loop(N, n_bit_modulus)
    global cache_file
    cf = open(cache_file, "w");
    m = sqrt(N);
    for i = 1:N
        msg = randstring(n_msg_str);
        if i % m == 0
            print("block $(Int(i/m)) -> "); 
        end
        pubkey, n, d, p, q = new_channel(n_bit_modulus); 

        # Cache to file 
        if do_fast
            write(cf, "$p;$q\n");
        else
            #= C = send_rsa(msg, pubkey, n); =#
            write(cf, "$msg;$p;$q;$n\n");
        end
    end
    close(cf);
end

function pairwise_crack(mods)
    cnt = 0;
    correct = 0;
    for j = i+1:length(mods)
        p = gcd(mods[i], mods[j]); 
        if p != 1
            cnt += 2; # 2 private keys comprimised per collision
            println("Found collision $cnt, Fraction: $(cnt/i)")
            # Retrieve private key
            P1 = crack(n1, p, ciph1);
            P2 = crack(n2, p, ciph2);
            correct += P1 == df[j, :msg];
            correct += P2 == df[i, :msg];
            # Print results
            println("\tOriginal Msg: $(df[j, :msg]), Cracked: $P1")
            println("\tOriginal Msg: $(df[i, :msg]), Cracked: $P2")
            println("\t% Correct: $(correct/cnt)\n")
        end
    end
end
 
function fast_check()
    if do_fast
        df = readtable(cache_file, separator=';', 
                names=[:p, :q]);
    else
        df = readtable(cache_file, separator=';', 
                names=[:msg, :p, :q, :modulus]);
    end
    p = df[:, :p];
    q = df[:, :q];
    s = [p;q];
    k = length(unique(s));
    r = length(s);
    println("s: $r, unq: $r")
    if length(unique(s)) < length(s)
        println("check it")
    end
    rf = open("bigresults.txt", "a+");
    write(rf, "$k;$r\n");
    close(rf);
end 

function crack(n, p, cipher)
    q = div(n, p);
    phi = (p-1)*(q-1);
    _, d, _ = ext_euclid(pubkey, phi);
    P = join(recv_rsa(cipher, d, n));
    return P
end
 
function test_channel()
    msg = "6qNu0qfmsM";
    pubkey, n, privkey, p, q = new_channel(n_bit_modulus); 
    C = send_rsa(msg, pubkey, n);
    println("$C, $n, $privkey, $p, $q")
    p = recv_rsa(C, privkey, n);
    println("$p, $msg")
    if join(p) == msg
        println("Channel looks good")
    end
end

function test_cracker()
    msg1 = randstring(n_msg_str);
    msg2 = randstring(n_msg_str);
    p1 = gen_rand_prime(n_bit_modulus - 1);
    p2 = gen_rand_prime(n_bit_modulus - 1);
    q = gen_rand_prime(n_bit_modulus - 1);
    n1 = p1*q;
    n2 = p2*q;
    ciph1 = send_rsa(msg1, pubkey, n1);
    ciph2 = send_rsa(msg2, pubkey, n2);
    p = gcd(n1, n2);
    if p != 1
        println("Collision found: q: $q, p2: $p2")
        P1 = crack(n1, p, ciph1);
        P2 = crack(n2, p, ciph2);
        # Print results
        println("\tOriginal Msg1: $msg1, Original Msg2: $msg2")
        println("\tCracked      : $(P1), Cracked:       $(P2)")
    end
end

function param_sweep()
    rng_type = set_rng_type("randu");
    global cache_file  
     
    for n_bit_modulus = 32:32 
        cache_file = ".$(rng_type)_$(N)_msgs_$(n_bit_modulus)_bits.csv"; 
        message_loop(N, n_bit_modulus);
        fast_check();
    end
end

function main() 
    test_channel();
    test_cracker();
    # Generate rsa msgs
    if resim_msgs 
        message_loop(N);
    end

    # Try to crack
    if do_crack
        fast_check();
    end
end

