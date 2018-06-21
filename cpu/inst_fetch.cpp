#include "Vinst_fetch.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Vinst_fetch *top = new Vinst_fetch;
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  top->trace(trace, 99);
  trace->open("inst_fetch.vcd");
  size_t tick = 0;
  top->clk = 1;
  while (!Verilated::gotFinish())
  {
      tick++;
      top->clk = !top->clk;
      top->eval();
      trace->dump(2 * tick);

      printf("%d\n", top->inst_o);
  }
  delete top;
  return 0;
}
