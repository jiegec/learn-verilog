`include "define.sv"
module ex_mem(
  input wire clk,
  input wire rst,

  input wire[`RegAddrBus] ex_wd,
  input wire ex_wreg,
  input wire[`RegBus] ex_wdata,

  input wire ex_whilo,
  input wire[`RegBus] ex_hi,
  input wire[`RegBus] ex_lo,

  output reg[`RegAddrBus] mem_wd,
  output reg mem_wreg,
  output reg[`RegBus] mem_wdata,

  output reg mem_whilo,
  output reg[`RegBus] mem_hi,
  output reg[`RegBus] mem_lo
);

    always_ff @(posedge clk) begin
        if (rst == `RstEnable) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroWord;

            mem_whilo <= `WriteDisable;
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;
        end else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;

            mem_whilo <= ex_whilo;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;
        end
    end

endmodule // ex_mem
