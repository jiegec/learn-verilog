.org 0x0
.global _start
.set noat

_start:
    ori $2, $0, 0x11
    andi $2, 0x10
    ori $3, $0, 0x100
    or $4, $3, $2
    or $4, $3, $2
    and $4, $3, $2
    xor $4, $3, $2
    nor $4, $3, $2
    ori $10, 0x1
    ori $10, 0x2
    ori $10, 0x4
    ori $10, 0x8
    ori $10, 0x10
    ori $10, 0x20
