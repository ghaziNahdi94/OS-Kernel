
#include "kernel.h"

void kernel_main() {
    char* video_mem = (char*) (0xB8000);

    char* name = "Ghazi NEHDI";

    int memory_index = 0;
    for(int i=0; i<11; i++) {
        video_mem[memory_index] = name[i];
        video_mem[memory_index + 1] = 12;
        memory_index += 2;
    }
}