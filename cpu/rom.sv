`include "define.v"
module rom(
  input wire ce,
  input wire[`InstAddrBus] addr,

  output reg[`InstBus] inst
);
    reg[`InstBus] rom[0:`InstMemNum-1];

    initial begin
        $readmemh ("rom.hex", rom);
    end

    always_comb begin
      if (ce == `ChipDisable) begin
        inst = `ZeroWord;
      end else begin
        inst = rom[addr[`InstMemNumLog2+1:2]];
      end
    end

endmodule // rom
