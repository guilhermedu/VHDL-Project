clean:
	rm -f work-*.cf *.vcd *.o accumulator_tb.vcd  accumulator_tb xor_gate_3_tb and_gate_2_tb or_gate_3_tb full_adder_tb adder_n_tb vector_register_tb triple_port_ram_tb

.PHONY:	accumulator_tb.vhd
accumulator_tb.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 accumulator.vhd adder_n.vhd  full_adder.vhd triple_port_ram.vhd vector_register.vhd accumulator.vhd accumulator_tb.vhd or_gate_3.vhd xor_gate_3.vhd and_gate_2.vhd barrel_shifter.vhd
	ghdl -m --std=08 accumulator_tb
	ghdl -r --std=08 accumulator_tb --stop-time=1000ns --vcd=accumulator.vcd
.PHONY: barrel_shifter_tb.vcd
barrel_shifter_tb.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 barrel_shifter.vhd barrel_shifter_tb.vhd
	ghdl -m --std=08 barrel_shifter_tb
	ghdl -r --std=08 barrel_shifter_tb --stop-time=1000ns --vcd=barrel_shifter_tb.vcd
.PHONY: xor_gate_3.vhd
xor_gate_3_tb.vcd:
	rm -f work-*.cf 
	ghdl -i --std=08 xor_gate_3.vhd xor_gate_3_tb.vhd
	ghdl -m --std=08 xor_gate_3_tb
	ghdl -r --std=08 xor_gate_3_tb --stop-time=1000ns --vcd=xor_gate_3.vcd

.PHONY: and_gate_2.vhd
and_gate_2_tb.vcd:
	rm -f work-*.cf 
	ghdl -i --std=08 and_gate_2.vhd and_gate_2_tb.vhd
	ghdl -m --std=08 and_gate_2_tb
	ghdl -r --std=08 and_gate_2_tb --stop-time=1000ns --vcd=and_gate_2_tb.vcd

.PHONY: or_gate_3.vhd
or_gate_3_tb.vcd:
	rm -f work-*.cf 
	ghdl -i --std=08 or_gate_3.vhd or_gate_3_tb.vhd
	ghdl -m --std=08 or_gate_3_tb
	ghdl -r --std=08 or_gate_3_tb --stop-time=1000ns --vcd=or_gate_3.vcd

.PHONY: full_adder.vhd
full_adder_tb.vcd:
	rm -f work-*.cf 
	ghdl -i --std=08 full_adder.vhd full_adder_tb.vhd or_gate_3.vhd and_gate_2.vhd xor_gate_3.vhd
	ghdl -m --std=08 full_adder_tb
	ghdl -r --std=08 full_adder_tb --stop-time=1000ns --vcd=full_adder.vcd

.PHONY: adder_n.vhd
adder_n_tb.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 adder_n.vhd adder_n_tb.vhd full_adder.vhd or_gate_3.vhd and_gate_2.vhd xor_gate_3.vhd
	ghdl -m --std=08 adder_n_tb
	ghdl -r --std=08 adder_n_tb --stop-time=1000ns --vcd=adder_n.vcd

.PHONY: vector_register.vhd
vector_register_tb.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 vector_register.vhd vector_register_tb.vhd
	ghdl -m --std=08 vector_register_tb
	ghdl -r --std=08 vector_register_tb --stop-time=1000ns --vcd=vector_register_tb.vcd
.PHONY: triple_port_ram.vhd
triple_port_ram_tb.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 triple_port_ram.vhd triple_port_ram_tb.vhd
	ghdl -m --std=08 triple_port_ram_tb
	ghdl -r --std=08 triple_port_ram_tb --stop-time=1000ns --vcd=triple_port_ram_tb.vcd
