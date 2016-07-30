#!/usr/local/bin/julia

# Packages
using JLD
using PyPlot

# Functions 
function run_rabbit_run(test, n)
    print("Run rabbit for $test and n = $n...");
    binname = join(["data/", test, ".bin"]);
    rabname = join(["data/", test, ".rab"]);
    prog = pwd() * "/run_rabbit";
    cmd = `$prog $binname $n`;
    run(pipeline(cmd, stdout=rabname));
    println("Success.") 
end

function parse_rabbit_parse(test)
    print("Parue rabbit for $test...");
    rabname = join(["data/", test, ".rab"]);
    x = Dict();

    # colon, spaces, word, spaces, *****
    name_reg = Regex("(\\w+)\\s*test:\n");
    re = Regex("p-value of test\\s+:\\s+(.+)\n");

    # retrieve rabbit results 
    f = open(rabname, "r");
    name = "";
    # parse p-values 
    for line in readlines(f)
        if ismatch(name_reg, line)
            m = match(name_reg, line);
            name = m.captures[1];
            try 
                name = name[collect(search(name, "_"))[1] + 1:end];
            catch
                continue; 
            end
        elseif ismatch(re, line)
            m = match(re, line);
            score = m.captures[1]; 
            score = replace(score, "*", "");
            score = replace(score, " ", "");
            score = replace(score, "eps", "$(eps())");
            score = eval(parse(score));
            if haskey(x, name)
                name = name*"2";
            end 
            println("algo: $test; test: $name; p-value:  $(score);");
            x[name] = score; 
        end
    end 
    close(f); 
    println("Success."); 
    return x
end

# Main 
d = Dict();
d["randu"] = Dict();
d["matV5"] = Dict();
d["mersenne"] = Dict();

d["randu"]["n"] = 10.^[3, 4, 5, 6];
d["matV5"]["n"] = 10.^[6, 7, 8, 9, 10, 11];
d["mersenne"]["n"] = 10.^[8, 9, 10, 11, 12];

#= testnames = ["randu"]; =#
do_plot = false;
 
# for each rng output, run Rabbit for various n, parse results and cache
for test in keys(d)
    for (i, N) in enumerate(d[test]["n"])
        println(repeat("*", 60)*"\n");
        run_rabbit_run(test, N);
        d[test]["score"] = parse_rabbit_parse(test);
        println(repeat("*", 60)*"\n");
    end
end

if do_plot
    figure(j)
    x = collect(values(D[test][i]));
    plot(x, "-*")
    xticks(0:length(x) - 1, collect(keys(D[test][i])))
    xticks(0:length(x) - 1, collect(keys(D[test][i])), rotation=90)
    savefig(test*".png");
end
