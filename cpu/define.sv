`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b1
`define InstInvalid 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0

// special, check op3
`define EXE_AND 6'b100100
`define EXE_OR 6'b100101
`define EXE_XOR 6'b100110
`define EXE_NOR 6'b100111

// special, check op3
`define EXE_MULT 6'b011000 // {hi, lo} <- rs * rt as signed
`define EXE_MULTU 6'b011001 // {hi, lo} <- rs * rt as unsigned

// check op
`define EXE_ANDI 6'b001100
`define EXE_ORI 6'b001101
`define EXE_XORI 6'b001110
`define EXE_LUI 6'b001111

// check op
`define EXE_ADDI 6'b001000 // rt <- rs + imm fail when overflow
`define EXE_ADDIU 6'b001001 // rt <- rs + imm
`define EXE_SLTI 6'b001010 // rt <- (rs < imm) as signed
`define EXE_SLTIU 6'b001011 // rt <- (rs < imm) as unsigned

// special2, check op3
`define EXE_CLZ 6'b100000 // rd <- leading zeros of rs
`define EXE_CLO 6'b100001 // rd <- leading ones of rs
`define EXE_MUL 6'b000010 // rd <- rs * rt

// check op3, when 31:21 are zeros
`define EXE_SLL 6'b000000 // logic left shift
`define EXE_SRL 6'b000010 // logic right shift
`define EXE_SRA 6'b000011 // arithmetic right shift

// special, check op3
`define EXE_SLLV 6'b000100 // logic left shift with variable
`define EXE_SRLV 6'b000110 // logic right shift with variable
`define EXE_SRAV 6'b000111 // arithmetic right shift with variable

// special, check op3
`define EXE_MOVN 6'b001011 // rd <- rs when rt non zero
`define EXE_MOVZ 6'b001010 // rd <- rs when rt zero
`define EXE_MFHI 6'b010000 // rd <- hi
`define EXE_MFLO 6'b010010 // rd <- lo
`define EXE_MTHI 6'b010001 // hi <- rs
`define EXE_MTLO 6'b010011 // lo <- rs

// special, check op3
`define EXE_ADD 6'b100000 // rd <- rs + rt fail when overflow
`define EXE_ADDU 6'b100001 // rd <- rs + rt
`define EXE_SUB 6'b100010 // rd <- rs - rt fail when overflow
`define EXE_SUBU 6'b100011 // rd <- rs - rt
`define EXE_SLT 6'b101010 // rd <- (rs < rt) as signed
`define EXE_SLTU 6'b101011 // rd <- (rs < rt) as unsigned

`define EXE_SPECIAL_INST 6'b000000 // check op3 for sub type
`define EXE_SPECIAL2_INST 6'b011100 // check op3 for sub type

// these are implemented as nop
// special, check op3
`define EXE_SYNC 6'b001111
// check op
`define EXE_PREF 6'b110011
// this is sll in fact
`define EXE_NOP 6'b000000

`define EXE_NOP_OP 8'b00000000
`define EXE_AND_OP 8'b00000001
`define EXE_OR_OP 8'b00000010
`define EXE_NOR_OP 8'b00000011
`define EXE_XOR_OP 8'b00000100

`define EXE_SLL_OP 8'b00000101
`define EXE_SRL_OP 8'b00000110
`define EXE_SRA_OP 8'b00000111

`define EXE_MFHI_OP 8'b00001000
`define EXE_MFLO_OP 8'b00001001
`define EXE_MOVZ_OP 8'b00001010
`define EXE_MOVN_OP 8'b00001011
`define EXE_MTHI_OP 8'b00001100
`define EXE_MTLO_OP 8'b00001101

`define EXE_RES_NOP 3'b000
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010
`define EXE_RES_MOVE 3'b011

`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071 // 128KB
`define InstMemNumLog2 17

`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b0000