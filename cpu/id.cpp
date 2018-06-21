#include "Vid.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  Verilated::commandArgs(argc, argv);
  Vid *top = new Vid;
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  top->trace(trace, 99);
  trace->open("id.vcd");

  size_t tick = 0;
  while (!Verilated::gotFinish())
  {
    top->rst = 0;
    top->pc_i = 0x12345678;
    // ori $10, $1, 0b0101010101010101
    top->inst_i = 0b001101'00001'01010'0101010101010101;
    // $1 = tick
    top->reg1_data_i = tick;
    top->eval();
    trace->dump(2 * tick);
    assert(top->reg1_o == tick); // first operand is $1
    assert(top->reg2_o == 0b0101010101010101); // second operand is imm

    top->rst = 1;
    top->eval();
    trace->dump(2 * tick + 1);
    tick++;
    usleep(100);
  }

  delete top;
  return 0;
}
