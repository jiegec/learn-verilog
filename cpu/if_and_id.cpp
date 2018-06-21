#include "Vif_and_id.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  Verilated::commandArgs(argc, argv);
  Vif_and_id *top = new Vif_and_id;
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  top->trace(trace, 99);
  trace->open("if_and_id.vcd");

  size_t tick = 0;
  while (!Verilated::gotFinish())
  {
    top->clk = 0;
    top->eval();
    trace->dump(2 * tick);

    top->clk = 1;
    top->eval();
    trace->dump(2 * tick + 1);
    tick++;
    usleep(100);
  }

  delete top;
  return 0;
}
