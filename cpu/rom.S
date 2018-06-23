.org 0x0
.global _start
.set noat

_start:
    ori $1, $0, 0x00000001
    ori $1, $1, 0x00000010
    ori $1, $1, 0x00000100
    ori $1, $1, 0x00001000
