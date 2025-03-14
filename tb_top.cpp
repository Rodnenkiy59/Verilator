// Verilator Example
// Norbertas Kremeris 2021
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <cstdint>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtop.h"

#define MAX_SIM_TIME 10000000
vluint64_t sim_time = 0;

void dut_reset (Vtop *dut, vluint64_t &sim_time){
    dut->rst_n = 1;
    if(sim_time >= 3 && sim_time < 6){
        dut->rst_n = 0;
    }
}

int main(int argc, char** argv, char** env) {
	Vtop *dut = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
	dut->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	std::string filename = "pixel_data.bin";
	// Открываем файл в бинарном режиме
    std::ofstream outFile(filename, std::ios::binary);

    if (!outFile.is_open()) {
        std::cerr << "Ошибка: Не удалось создать файл " << filename << std::endl;
        return 0;
    }

	uint8_t red;    // Красный компонент (0-255)
    uint8_t green;  // Зеленый компонент (0-255)
    uint8_t blue;  	// Синий компонент (0-255)

	uint8_t r;    // Красный компонент (0-255)
    uint8_t g;  // Зеленый компонент (0-255)
    uint8_t b;  	// Синий компонент (0-255)

	while (sim_time < MAX_SIM_TIME && (dut->lcd_xpos < 800 && dut->lcd_ypos < 480)) {
		dut_reset(dut, sim_time);

		dut->clk ^= 1;
		dut->eval();	

		red 	= (dut->lcd_data>>16) & 0xFF;
		green 	= (dut->lcd_data>>8) & 0xFF;
		blue 	= (dut->lcd_data) & 0xFF;

		if (dut->lcd_de != 0){
			outFile.write(reinterpret_cast<char*>(&red), sizeof(uint8_t));
            outFile.write(reinterpret_cast<char*>(&green), sizeof(uint8_t));
            outFile.write(reinterpret_cast<char*>(&blue), sizeof(uint8_t));
		}
		
		m_trace->dump(sim_time);
		sim_time++;
	}

	outFile.close();

    // std::ifstream inFile(filename, std::ios::binary);
    // if (!inFile.is_open()) {
    //     std::cout << "Ошибка открытия файла для чтения!" << std::endl;
    //     return 1;
    // }

    // for (int y = 0; y < 5; y++) {
    //     for (int x = 0; x < 5; x++) {
    //         uint8_t r, g, b;
    //         inFile.read(reinterpret_cast<char*>(&r), sizeof(uint8_t));
    //         inFile.read(reinterpret_cast<char*>(&g), sizeof(uint8_t));
    //         inFile.read(reinterpret_cast<char*>(&b), sizeof(uint8_t));
            
    //         // Выводим первые несколько значений для проверки
    //         if (x < 5 && y < 5) {
    //             std::cout << "Pixel (" << x << "," << y << "): R=" << (int)r 
    //                  << " G=" << (int)g << " B=" << (int)b << std::endl;
    //         }
    //     }
    // }

	// std::cout << ("Sim time =", sim_time) << std::endl;

	// inFile.close();

	m_trace->close();
	delete dut;
	exit(EXIT_SUCCESS);
}