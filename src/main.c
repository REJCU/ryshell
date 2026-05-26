#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "./parser.c"
#include <sys/types.h>
#include "builtins.h"



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

int lsh_launch(char **args)
{
    pid_t, wpid; 
    int status;

    pid = fork();
    if (pid == 0) {
        // child proccesss
        if (execvp(args[0], args) == -1) {
            perror("lsh");
        }
        exit(EXIT_FAILURE);
    } else if (pid < 0) {
        // error forking 
        perror("lsh");
    } else {
        // parrent process
        do {
            wpid = waitpid(pid, &status, WUNTRACED);
        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
    }

    return 1;
}

int lsh_launch(char **args)
{
    int i;

    if (args[0] == NULL) {
        // empty command was entered 
        return 1;
    }

    for (i = 0; i < lsh_num_builtins(); i++) {
        if (strcmp(args[0], builtin_str[i])== 0) {
            return (*builtin_func[i])(args);
        }
    }

    return lsh_launch(args);
}


int main(int argc, char **argv)
{   // load config files if any 
    
    // run command loop
    lsh_loop();

    //perform any shutdown/cleanup
    
    return EXIT_SUCCESS;
}
