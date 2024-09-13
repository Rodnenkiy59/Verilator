#include "Vtop.h"       // Замена "top" на имя вашего верхнего модуля
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

vluint64_t main_time = 0;

double sc_time_stamp () { 
    return main_time; 
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    // Инициализация VCD трассировщика
    VerilatedVcdC* tfp = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    top->trace(tfp, 99);  // Максимально возможный уровень трассировки
    tfp->open("waveform.vcd");

    top->clk = 0;
    top->reset = 1;

    // Симуляционный цикл
    for (int i = 0; i < 100; i++) {
        if (i == 2) {
            top->reset = 0;
        }

        top->clk = !top->clk;
        top->eval();
        tfp->dump(main_time);
        main_time += 5;
    }

    // Завершение записи и закрытие файла
    tfp->close();
    delete top;
    delete tfp;
    return 0;
}
