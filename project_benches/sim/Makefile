export PROJ_HOME  ?= $(PWD)/../..
export PROJ_VIP_HOME ?= $(PROJ_HOME)/verification_ip
export QUESTA_HOME ?= /opt/questasim
export PROJ_PB_HOME ?= $(PROJ_HOME)/project_benches

export COMP_HDL ?= vlog -sv

COMP_OPT ?= vopt +acc

SV_SEED ?= 123456789
UVM_TEST ?= test_top
VERBOSITY ?= UVM_NONE
LOGS ?= run
READS ?= 5
WRITES ?= 5
COV_EN ?= 1
PRE_EN ?= 0
RUNS ?= 10
COV_NAME ?= test_top


# Include all requisite interface package targets for this bench
include $(PROJ_VIP_HOME)/interface_packages/axi_if/Makefile

# Include all requisite environment package targets for this bench
include $(PROJ_VIP_HOME)/environment_packages/axi_env/Makefile

# Include tests package importing
include $(PROJ_PB_HOME)/tb/tests/Makefile

comp_axi_dut:
	$(COMP_HDL) +incdir+$(PROJ_PB_HOME)/rtl $(PROJ_PB_HOME)/rtl/axi_mem.sv

comp_test_bench:
	$(COMP_HDL) +incdir+$(PROJ_PB_HOME)/tb/testbenches $(PROJ_PB_HOME)/tb/testbenches/hdl_top.sv $(PROJ_PB_HOME)/tb/testbenches/hvl_top.sv

comp_opt: comp_axi_dut comp_axi_pkg comp_env_pkg comp_test_pkg comp_test_bench
	$(COMP_OPT) hdl_top hvl_top -o hvl_top_opt

# -qwavedb=+signal+memory+transaction=1024+report+parameter+class+assertion+uvm_schematic+msg+classmemory=1024+statictaskfunc 
# comp_axi_dut comp_axi_pkg comp_env_pkg comp_test_pkg comp_test_bench
qrun: 
	qrun -64 \
	-sv_seed $(SV_SEED) \
	-gui \
	-coverage \
	-onfinish stop \
	-classdebug \
	-uvmcontrol=all \
	-msgmode both \
	-l $(UVM_TEST).log \
	-f filelist.f \
	-do process.do \
	+UVM_TESTNAME=$(UVM_TEST) -debug,livesim \
	+UVM_VERBOSITY=$(VERBOSITY) \
	+READS=$(READS) \
	+WRITES=$(WRITES) \
	+COV_EN=$(COV_EN) \
	+PRE_EN=$(PRE_EN) \
	+RUNS=$(RUNS) \
	-top hdl_top \
	-top hvl_top

cli: 
	qrun -64 \
	-sv_seed $(SV_SEED) \
	-coverage \
	-onfinish stop \
	-classdebug \
	-uvmcontrol=all \
	-msgmode both \
	-l logs/$(UVM_TEST).log \
	-f filelist.f \
	-do cli.do \
	+UVM_TESTNAME=$(UVM_TEST) -debug,livesim \
	+UVM_VERBOSITY=$(VERBOSITY) \
	+READS=$(READS) \
	+WRITES=$(WRITES) \
	+COV_EN=$(COV_EN) \
	+PRE_EN=$(PRE_EN) \
	+RUNS=$(RUNS) \
	-top hdl_top \
	-top hvl_top

viewcover: mergecover
	vsim -viewcov $(COV_NAME).ucdb

mergecover:
	vcover merge final.ucdb test_top_$(SV_SEED).ucdb direct_test_seq_wr_$(SV_SEED).ucdb

clean:
	rm -rf work
	rm -rf certe_dump.xml
	rm -rf design.bin
	rm -rf qrun.out
	rm -rf .visualizer
	rm -rf qwave.db
	rm -rf logs/*.log
	rm -rf *.ucdb
	rm -rf transcript
	rm -rf *.wlf