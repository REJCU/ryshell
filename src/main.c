#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "./parser.c"
#include <sys/types.h>
#include "builtins.h"
#include <string.h>
#include "./builtin.c"


void lsh_loop(void)
{
    char *line;
    char **args;
    int status;

    do {
        printf("> ");
        line = lsh_read_line();
        args = lsh_split_line(line);
        status = lsh_execute(args);

        free(line);
        free(args);
    } while (status);
}

int main(int argc, char **argv)
{   // load config files if any 
    
    // run command loop
    lsh_loop();

    //perform any shutdown/cleanup
    
    return EXIT_SUCCESS;
}
