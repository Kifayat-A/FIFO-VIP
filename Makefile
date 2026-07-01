TB ?= array.sv
TB_TOP ?= top
DUT ?= /home/kifayat/Desktop/subsys-verif/build/hw/verilog/ISP_Subsystem_v0.8.1/SizedFIFO.v
VLOG_FLAGS = -L mtiUvm
VSIM_FLAGS = -c -do "run -all; quit" -uvmcontrol=all +UVM_NO_RELNOTES -sv_seed random +define+BSV_POSITIVE_RESET

all: lib compile sim

lib:
	vlib work

compile:
	vlog $(VLOG_FLAGS) $(DUT) $(TB)

sim:
	vsim -voptargs="+acc" $(VSIM_FLAGS) $(TB_TOP)

gui:
	vsim -voptargs="+acc" $(TB_TOP)

clean:
	rm -rf work vsim.wlf transcript
