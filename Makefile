# Verilator example makefile
# Norbertas Kremeris 2021
MODULE=top

# RTL_module
RTLSRC += hdl/lcd_ctrl.sv
RTLSRC += hdl/lcd_data.sv

.PHONY:sim
sim: waveform.vcd

.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: obj_dir/Vtop

.PHONY:waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd

waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	./obj_dir/V$(MODULE) +verilator+rand+reset+2 

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE).sv tb_$(MODULE).cpp
	@echo
	@echo "### VERILATING ###"
	verilator -Wall --trace --x-assign unique --x-initial unique -cc $(MODULE).sv $(RTLSRC)  --exe tb_$(MODULE).cpp
	@touch .stamp.verilate

.PHONY:lint
lint: $(MODULE).sv
	verilator --lint-only $(MODULE).sv

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd
	rm -rf pixel_data.bin
	rm -rf output.png

.PHONY: create_img
create_img:
	@echo "### RUNNING PYTHON SCRIPT ###"
	python3 scripts/convert_to_image.py

help:
	@echo "Доступные цели:"
	@echo "  make        - build project and write to waveform"
	@echo "  make build  - build project "
	@echo "  make sim    - write to waveform "
	@echo "  make clean  - clean project"
	@echo "  create_img  - create img from lcd"
	@echo "  make help   - show this"
