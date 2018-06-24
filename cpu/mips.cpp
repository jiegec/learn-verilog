#include "Vmips.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

size_t tick = 0;

double sc_time_stamp() {
  return (double)tick;
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Vmips *top = new Vmips;
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  top->trace(trace, 99);
  trace->open("mips.vcd");

  while (!Verilated::gotFinish()) {
    top->clk = 0;
    top->eval();
    tick++;
    trace->dump(tick);

    top->clk = 1;
    top->eval();
    tick++;
    trace->dump(tick);
    usleep(100);
  }

  delete top;
  return 0;
}
