BUILD_DIR=build
TOP=exp01
TB_TOP=tb_exp01
V_TOP=$(TOP).v
V_TB=$(TB_TOP).v
V_PLL=pll.v
V_SRC=blinky.v dual_timer.v
V_SYNTH=$(V_TOP) $(V_PLL) $(V_SRC)
V_SRC_SIMPLE=$(BUILD_DIR)/simplified.v
V_SIM=$(V_TB) $(V
SIM_VVP=$(BUILD_DIR)/$(TB_TOP).vvp
SIM_VCD=$(BUILD_DIR)/$(TB_TOP).vcd
JSON=$(BUILD_DIR)/$(TOP).json
YLOG=$(BUILD_DIR)/yosys.log
ASC=$(BUILD_DIR)/$(TOP).asc
NLOG=$(BUILD_DIR)/nextpnr-ice40.log
BIN=$(BUILD_DIR)/$(TOP).bin
PKG=--up5k --package sg48
PCF=ice40up5k-b-evn.pcf
PRE_PACK=pre_pack.py
CRYSTAL_MHZ=12
CLOCK_MHZ=24

$(BIN): $(ASC)
	icepack $(ASC) $(BIN)
	@printf "\n=========================\n=== Build Log Summary ===\n=========================\n"
	@printf "\n== yosys warnings and errors ==\n\n"
	@grep -i 'warn\|error' $(YLOG) || echo "<none>"
	@printf "\n== nextpnr-ice40 warnings and errors ==\n\n"
	@grep -i 'warn\|error' $(NLOG) || echo "<none>"
	@printf "\n== yosys stats ==\n\n"
	@egrep -i '^\s+SB_|number of cells' $(YLOG) || echo "<none>"
	@printf "\n== nextpnr-ice40 timing and device utilisation ==\n\n"
	@grep -i 'max frequency' $(NLOG) && echo || true
	@grep -A 15 'Info: Device utilisation' $(NLOG) || true

prog: $(BIN)
	iceprog $(BIN)

$(ASC): $(JSON) $(PCF) $(PRE_PACK)
	nextpnr-ice40 $(PKG) -l $(NLOG) --pcf $(PCF) --pre-pack $(PRE_PACK) --json $(JSON) --asc $(ASC)

sim: $(V_TB) $(V_SRC) $(BUILD_DIR)
# dual_timer.v uses SystemVerilog static casts. Yosys can handle them fine with
# -sv, but iverilog needs plain verilog. This flow uses yosys to convert
# blinky.v and dual_timer.v into simpler verilog. It's important not to convert
# the testbench, because yosys would strip $dumpfile() system task, which would
# break the simulation.
	yosys -q -p 'read_verilog -sv $(V_SRC); proc; write_verilog $(V_SRC_SIMPLE)'
	iverilog -o $(SIM_VVP) $(V_SRC_SIMPLE) $(V_TB)
	vvp $(SIM_VVP)

YS_SCRIPT=read_verilog -sv -noautowire $(V_SYNTH); synth_ice40 -top $(TOP) -json $(JSON)
$(JSON): $(V_SYNTH) $(BUILD_DIR)
	yosys -q -l $(YLOG) -p '$(YS_SCRIPT)'

$(V_PLL):
	icepll -i $(CRYSTAL_MHZ) -o $(CLOCK_MHZ) -m -f $(V_PLL)
	sed -i 's/SB_PLL40_CORE/SB_PLL40_PAD/' $(V_PLL)
	sed -i 's/REFERENCECLK/PACKAGEPIN/' $(V_PLL)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -f $(JSON) $(ASC) $(BIN) $(YLOG) $(NLOG) $(V_SRC_SIMPLE) $(SIM_VVP) $(SIM_VCD)
	rmdir $(BUILD_DIR)

.PHONY: clean
