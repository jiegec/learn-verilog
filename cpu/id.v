`include "define.v"
module id(
    input wire rst,
    input wire[`InstAddrBus] pc_i,
    input wire[`InstBus] inst_i,

    input wire[`RegBus] reg1_data_i, // read reg1 data
    input wire[`RegBus] reg2_data_i, // read reg2 data

    output reg reg1_read_o, // read reg1 or not
    output reg reg2_read_o, // read reg2 or not
    output reg[`RegAddrBus] reg1_addr_o, // read reg1 num
    output reg[`RegAddrBus] reg2_addr_o, // read reg2 num

    output reg[`AluOpBus] aluop_o, // alu op
    output reg[`AluSelBus] alusel_o, // alu selector
    output reg[`RegBus] reg1_o, // reg1 passed to alu
    output reg[`RegBus] reg2_o, // reg2 passed to alu
    output reg[`RegAddrBus] wd_o, // output register num
    output reg wreg_o // output enabled
);
    wire[5:0] op = inst_i[31:26]; // op type
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];

    reg[`RegBus] imm;
    reg instvalid;

    always @ (*) begin
      if (rst == `RstEnable) begin
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= `NOPRegAddr;
        wreg_o <= `WriteDisable;
        instvalid <= `InstValid;
        reg1_read_o <= 1'0;
        reg2_read_o <= 1'0;
        reg1_addr_o <= `NOPRegAddr;
        reg2_addr_o <= `NOPRegAddr;
        imm <= `ZeroWord;
      end else begin
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= inst_i[15:11];
        wreg_o <= `WriteDisable;
        instvalid <= `InstInvalid;
        reg1_read_o <= 1'0;
        reg2_read_o <= 1'0;
        reg1_addr_o <= inst_i[25:21];
        reg2_addr_o <= inst_i[20:16];
        imm <= `ZeroWord;

        case (op)
          `EXE_ORI: begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'1; // read source from rs
            reg2_read_o <= 1'0; // use imm
            // unsigned extend
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
          end
          default: begin
            
          end
        endcase
      end
    end

    always @ (*) begin
      if (rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
      end else if (reg1_read_o == 1'b1) begin
        reg1_o <= reg1_data_i;
      end else if (reg1_read_o == 1'b0) begin
        reg1_o <= imm;
      end else begin
        reg1_o <= `ZeroWord;
      end
    end

    always @ (*) begin
      if (rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
      end else if (reg2_read_o == 1'b1) begin
        reg2_o <= reg2_data_i;
      end else if (reg2_read_o == 1'b0) begin
        reg2_o <= imm;
      end else begin
        reg2_o <= `ZeroWord;
      end
    end

endmodule // id