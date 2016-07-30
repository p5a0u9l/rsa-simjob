#A Review of Random Number Generation in Cryptographic Applications
## EE595: Course Project - Proposal
### Prepared by Paul Adams


## Introduction
I find the problem of generating randomness in cryptography to be very interesting. There is a fundamental trade-off between the randomness of a cryptographic method and the inherent practicality. One-time pads are both the most secure and the most impractical method of secure communications. It is widely assumed that with modern computing strong encryption is cheap, but researchers and hackers continue to reveal the insecurity of many systems and companies. 

A focus of my technical work is algorithms and software and I would like a projet that includes some coding and numerical analysis. 
  
## Problem Description
### System
Random number generation is a central element of almost any information system's security profile. RNGs are often used to bootstrap trust between two communicating digital entities. As such, the security of the channel, assuming no other flaws, is only as strong as the unpredicability of the keys exchanged to secure the session. As an example, if a website issued the same 5 digit number as a private key every time a client connected, an attacker could predict the next key with 100% accuracy once the 5 digit number was found. 

### Vulnerabilities
Most computer systems rely on an algorithm to generate randomness. These are referred to as Pseudo-random generators (PRNG). It intuitively follows that any stream from a deterministic (formula or algorithm) source can not be truly random. The vulnerability associated with PRNGs in computer systems arises from whether or not the stream is sufficiently unpredictable to an outside observer. 

## Proposed Approach
### RANDU - a naively insecure RNG
I will review the algorithm behind an infamous example of a bad RNG and why it fails to be cryptographically secure. As part of this review, I will write code to implement the algorithm and then analyze it. 

### Blum-Blum-Shub - a secure RNG 
I will review the seminal work by Blum, Blum and Shub as a standard for a cryptographically secure RNG. I will also attempt to implement their algorithm in code, or borrow an open-source implementation. 

### NIST Randomness Beacon - a true RNG
The NIST randomness beacon [http://www.nist.gov/itl/csd/ct/nist_beacon.cfm] uses quantum state measurements to generate truly random numbers and posts these in 512 bit blocks to a simple web API. I will write code to download their entire stream and then attempt to evaluate it's qualities. 
  
### Entropy Estimation - Comparing Randomness
I will refer to the paper by Chakrabarti, Cormode and McGregor entitled "A Near-Optimal Algorithm for Estimating the Entropy of a Stream" to compare the quality of PRNGs and a TRNG. 

### Reference List
1. Blum, Blum, and Shub - Comparison of Two Pseudo-Random Number Generators
2. Chakrabarti, Cormode, and McGregor - A Near-Optimal Algorithm for Estimating the Entropy of a Stream
