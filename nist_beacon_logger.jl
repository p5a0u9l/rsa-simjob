#!/usr/local/bin/julia
 


base_url = "https://beacon.nist.gov/rest/record/";
first_stamp = 1378370340;
freq = 60;

while true
    # Round to nearest (next) minute
    cur_stamp = round(Int64, floor(time()/freq))*freq;
    request = `wget --quiet $base_url$cur_stamp`;
    run(request);
    println("Record: $cur_stamp at $(now()) --> Success.");
    sleep(freq);
end

