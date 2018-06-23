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
    output reg wreg_o, // output enabled

    // check if the data is changed in last or the one before last inst
    input wire ex_wreg_i, // last
    input wire[`RegBus] ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,

    input wire mem_wreg_i, // the one before last
    input wire[`RegBus] mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i
);
    wire[5:0] op = inst_i[31:26]; // op type
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0]; // for special inst
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
        wd_o <= inst_i[15:11]; // default to rd
        wreg_o <= `WriteDisable;
        instvalid <= `InstInvalid;
        reg1_read_o <= 1'0;
        reg2_read_o <= 1'0;
        reg1_addr_o <= inst_i[25:21]; // default to rs
        reg2_addr_o <= inst_i[20:16]; // default to rt
        imm <= `ZeroWord;

        case (op)
          `EXE_SPECIAL_INST: begin
            case (op2)
              5'b00000:  begin
                case (op3)
                  `EXE_OR:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_OR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  `EXE_AND:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_AND_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  `EXE_XOR:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_XOR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  `EXE_NOR:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_NOR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  `EXE_SLLV:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_SLL_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  `EXE_SRLV:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_SRL_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  `EXE_SRAV:  begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_SRA_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    reg1_read_o <= 1'b1; // read 1st operand from rs
                    reg2_read_o <= 1'b1; // read 2nd operand from rt
                    instvalid <= `InstValid;
                  end
                  // nop
                  `EXE_SYNC:  begin
                    wreg_o <= `WriteDisable;
                    aluop_o <= `EXE_NOP_OP;
                    alusel_o <= `EXE_RES_NOP;
                    reg1_read_o <= 1'b0;
                    reg2_read_o <= 1'b0;
                    instvalid <= `InstValid;
                  end
                  default: begin
                    
                  end
                endcase
              end
              default: begin
              end
            endcase
          end
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
          `EXE_ANDI: begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_AND_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'1; // read source from rs
            reg2_read_o <= 1'0; // use imm
            // unsigned extend
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
          end
          `EXE_XORI: begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_XOR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'1; // read source from rs
            reg2_read_o <= 1'0; // use imm
            // unsigned extend
            imm <= {16'h0, inst_i[15:0]};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
          end
          `EXE_LUI: begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'1; // read source from rs
            reg2_read_o <= 1'0; // use imm
            // raise to upper
            imm <= {inst_i[15:0], 16'h0};
            wd_o <= inst_i[20:16];
            instvalid <= `InstValid;
          end
          // nop
          `EXE_PREF: begin
            wreg_o <= `WriteDisable;
            aluop_o <= `EXE_NOR_OP;
            alusel_o <= `EXE_RES_NOP;
            reg1_read_o <= 1'0;
            reg2_read_o <= 1'0;
            instvalid <= `InstValid;
          end
          default: begin
          end
        endcase

        // sll, srl and sra
        if (inst_i[31:21] == 11'b0000000000) begin
          if (op3 == `EXE_SLL) begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_SLL_OP;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b1;
            imm[4:0] <= inst_i[10:6];
            wd_o <= inst_i[15:11];
            instvalid <= `InstValid;
          end else if (op3 == `EXE_SRL) begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_SRL_OP;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b1;
            imm[4:0] <= inst_i[10:6];
            wd_o <= inst_i[15:11];
            instvalid <= `InstValid;
          end else if (op3 == `EXE_SRA) begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_SRA_OP;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b1;
            imm[4:0] <= inst_i[10:6];
            wd_o <= inst_i[15:11];
            instvalid <= `InstValid;
          end
        end

        if (instvalid == `InstInvalid) begin
          $display("Invalid or unsupported instruction %h", inst_i);
        end
      end
    end

    always @ (*) begin
      if (rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
      end else if ((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) &&
                   (ex_wd_i == reg1_addr_o)) begin
        // the reg is overwritten in last inst.
        reg1_o <= ex_wdata_i;
      end else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) &&
                   (mem_wd_i == reg1_addr_o)) begin
        // the reg is overwritten in the one before last inst.
        reg1_o <= mem_wdata_i;
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
      end else if ((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) &&
                   (ex_wd_i == reg2_addr_o)) begin
        // the reg is overwritten in last inst.
        reg2_o <= ex_wdata_i;
      end else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) &&
                   (mem_wd_i == reg2_addr_o)) begin
        // the reg is overwritten in the one before last inst.
        reg2_o <= mem_wdata_i;
      end else if (reg2_read_o == 1'b1) begin
        reg2_o <= reg2_data_i;
      end else if (reg2_read_o == 1'b0) begin
        reg2_o <= imm;
      end else begin
        reg2_o <= `ZeroWord;
      end
    end

endmodule // id