`include "define.v"
module if_and_id(
    input wire clk,
    input wire rst
);

    wire[`InstAddrBus] pc;
    wire rom_ce;

    wire[`InstAddrBus] rom_data;
    wire[`InstAddrBus] id_pc_i;
    wire[`InstBus] id_inst_i;

    wire[`AluOpBus] id_aluop_o;
    wire[`AluSelBus] id_alusel_o;
    wire[`RegBus] id_reg1_o;
    wire[`RegBus] id_reg2_o;
    wire id_wreg_o;
    wire[`RegAddrBus] id_wd_o;

    wire wb_wreg_i;
    wire[`RegAddrBus] wb_wd_i;
    wire[`RegBus] wb_wdata_i;

    wire reg1_read; // read reg1 or not
    wire reg2_read;
    wire[`RegBus] reg1_data; // the data of reg1
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr; // the index or reg1
    wire[`RegAddrBus] reg2_addr;

    pc_reg pc_reg0(.clk(clk), .rst(rst),
                    .pc(pc), .ce(rom_ce));
    rom rom0(.ce(rom_ce), .addr(pc), .inst(rom_data));

    if_id if_id0(.clk(clk), .rst(rst), .if_pc(pc), .if_inst(rom_data),
                 .id_pc(id_pc_i), .id_inst(id_inst_i));

    id id0(.rst(rst), .pc_i(id_pc_i), .inst_i(id_inst_i),
            .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
            .reg1_read_o(reg1_read), .reg2_read_o(reg2_read),
            .reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
            .aluop_o(id_aluop_o), .alusel_o(id_alusel_o),
            .reg1_o(id_reg1_o), .reg2_o(id_reg2_o),
            .wd_o(id_wd_o), .wreg_o(id_wreg_o));

    regfile regfile0(.clk(clk), .rst(rst),
                    .we(wb_wreg_i), .waddr(wb_wd_i),
                    .wdata(wb_wdata_i), .re1(reg1_read),
                    .raddr1(reg1_addr), .rdata1(reg1_data),
                    .re2(reg2_read), .raddr2(reg2_addr),
                    .rdata2(reg2_data));

endmodule // if_and_id