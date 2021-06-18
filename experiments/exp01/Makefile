BUILD_DIR=build
TOP=exp01
V_TOP=$(TOP).v
V_PLL=pll.v
V_SRC=blinky.v dual_timer.v
V_SYNTH=$(V_TOP) $(V_PLL) $(V_SRC)
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

YS_SCRIPT=read_verilog -sv -noautowire $(V_SYNTH); synth_ice40 -top $(TOP) -json $(JSON)
$(JSON): $(V_SYNTH)
	mkdir -p $(BUILD_DIR)
	yosys -q -l $(YLOG) -p '$(YS_SCRIPT)'

$(V_PLL):
	icepll -i $(CRYSTAL_MHZ) -o $(CLOCK_MHZ) -m -f $(V_PLL)
	sed -i 's/SB_PLL40_CORE/SB_PLL40_PAD/' $(V_PLL)
	sed -i 's/REFERENCECLK/PACKAGEPIN/' $(V_PLL)

clean:
	rm -f $(JSON) $(ASC) $(BIN) $(YLOG) $(NLOG)
	rmdir $(BUILD_DIR)

.PHONY: clean
