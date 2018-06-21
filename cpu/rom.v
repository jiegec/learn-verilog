`include "define.v"
module rom(
  input wire ce,
  input wire[`InstAddrBus] addr,

  output reg[`InstBus] inst
);
    reg[`InstBus] rom[0:`InstMemNum-1];

    initial begin
        $readmemb ("rom.data", rom);
    end

    always @(*) begin
      if (ce == `ChipDisable) begin
        inst <= `ZeroWord;
      end else begin
        inst <= rom[addr[`InstMemNumLog2+1:2]];
      end
    end

endmodule // rom
