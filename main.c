#include <unistd.h>


int main(int argc, char *argv[])
{
    char *path = "/usr/bin/ssh";
    argv[0] = "ssh";
    execv(path,argv);
}