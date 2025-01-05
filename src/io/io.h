#ifndef IO_H
#define IO_H

#include <stdint.h>

unsigned char  readByte(unsigned short port);
unsigned readWord(unsigned short port);

void writeByte(unsigned short port, unsigned short value);
void writeWord(unsigned short port, unsigned char value);

#endif