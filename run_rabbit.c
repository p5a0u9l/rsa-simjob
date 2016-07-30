#include "usoft.h"
#include "unif01.h"
#include "bbattery.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main (int argc, char* argv[])
{
    unif01_Gen *gen;
    /* int n = 1024*1024; */
    int n = atoi(argv[2]);
    /* printf("look here: %s\n", argv[1]); */

    /* Test the first n bits of binary file vax.bin */
     
    bbattery_RabbitFile (argv[1], n);
    /* bbattery_AlphabitFile (argv[1], n); */

    return 0;
}
