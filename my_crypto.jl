global v_prev = 13; #init state of randu 
global rng_type

function set_rng_type(this)
    global rng_type = this;
    return rng_type
end

function gen_rand_prime(n)
    global v_prev;
    global rng_type;
     
    v_cur = 0;
    done = false;
    while !done
        if rng_type == "mersenne"
            v_cur = mersenne_twister();
             
        elseif rng_type == "randu"
            v_cur = mod(65539*v_prev, 2^n);

        end
        # repeat if number not prime 
        v_prev = v_cur;
        if isprime(v_cur)
            done = true;
        end
    end
    return v_cur 
end

function modular_pow(base, expon, modulus)
    # fast method by Bruce Schneier adapted from 
    # https://en.wikipedia.org/wiki/Modular_exponentiation
    result = BigInt(1);

    base = BigInt(mod(base, modulus));
    expon = BigInt(expon);
    modulus = BigInt(modulus);
     
    while expon > 0
        #= println("result: $result, expon: $expon"); =#
        if mod(expon, 2) == 1
            result = mod((result * base), modulus);
        end

        expon = expon >> 1;
        base = mod((base * base), modulus);
    end 
    return result
end

function new_channel(n) 
    n_bit_modulus = n;
    pubkey = BigInt(1073741827);
    p, q = 1, 1;

    # generate random p/q prime pair 
    done = false;
    while !done
        p = gen_rand_prime(n_bit_modulus-1);
        q = gen_rand_prime(n_bit_modulus-1);
        # Verify numbers coprime with pubkey 
        if mod(p, pubkey) != 1 && mod(q, pubkey) != 1
            done = true;
        end
    end 

    # compute modulus 
    n = BigInt(p*q);
    phi = (p - 1)*(q - 1);

    # compute secret key, d
    _, privkey, _ = ext_euclid(pubkey, phi);
    return (pubkey, n, privkey, p, q) 
end

function send_rsa(msg, pubkey, n) 
    msg_num = [Int(M[1]) for M in msg];
    cipher = [modular_pow(x, pubkey, n) for x in msg_num];
    return cipher 
end 

function recv_rsa(c, prikey, n) 
    plain = [modular_pow(y, prikey, n) for y in c];
    plaintext = [Char(p) for p in plain];
    return plaintext 
end 

function ext_euclid(a, b)
    a0, b0, = a, b;
    t0, t = 0, 1
    s0, s = 1, 0
    q = div(a, b)
    r = a - q*b
    while r > 0
        tmp = t0 - q*t;
        t0, t = t, tmp;
        tmp = s0 - q*s;
        s0, s = s, tmp;
        a, b = b, r;
        q = div(a, b);
        r = a - q*b;
    end
    r = b;
    if s < 0
        s = mod(s, b0);
    end
    if t < 0
        t = mod(t, a0);
    end
    return (r, s, t)
end

function totient(n)
    P = 1;
    for p in keys(factor(n))
        if isprime(p)
            P *= (1 - 1/p);     
        end
    end
    return round(Int64, P*n)
end

mt = MersenneTwister(29);
function mersenne_twister()
    # default mersenne twister wrapper
    x = parse(dec(rand(mt, UInt32, 1)[1]));
    return x
end

function abc2num(a)
    num = [parse(Int, s) for s in a];
    num -= parse(Int, 'a');
    return num[1]
end

function num2abc(n)
    a_offset = 97;
    abc = Char(n + a_offset);
    return abc[1]
end

