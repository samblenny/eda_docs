TOP_MOD=exp01
BUILD_DIR=build
V_IN=$(TOP_MOD).v
JSON=$(BUILD_DIR)/$(TOP_MOD).json
YLOG=$(BUILD_DIR)/yosys.log
ASC=$(BUILD_DIR)/$(TOP_MOD).asc
NLOG=$(BUILD_DIR)/nextpnr-ice40.log
BIN=$(BUILD_DIR)/$(TOP_MOD).bin
PKG=--up5k --package sg48
PLL_V=pll.v
PCF=ice40up5k-b-evn.pcf
PRE_PACK=pre_pack.py
CRYSTAL_MHZ=12
CLOCK_MHZ=24

YS_SCRIPT=read_verilog -noautowire $(V_IN); synth_ice40 -top $(TOP_MOD) -json $(JSON)

$(BIN): $(ASC)
	icepack $(ASC) $(BIN)
	@printf "\n=========================\n=== Build Log Summary ===\n=========================\n"
	@printf "\n== yosys warnings and errors ==\n\n"
	@grep -i 'warn\|error' $(YLOG) || echo "<none>"
	@printf "\n== nextpnr-ice40 warnings and errors ==\n\n"
	@grep -i 'warn\|error' $(NLOG) || echo "<none>"
	@printf "\n== nextpnr-ice40 timing and device utilisation ==\n\n"
	@grep -i 'frequency\|timing' $(NLOG) && echo || true
	@grep -A 15 'Info: Device utilisation' $(NLOG) || true

prog: $(BIN)
	iceprog $(BIN)

$(ASC): $(JSON) $(PCF) $(PRE_PACK)
	nextpnr-ice40 $(PKG) -l $(NLOG) --pcf $(PCF) --pre-pack $(PRE_PACK) --json $(JSON) --asc $(ASC)

$(JSON): $(PLL_V) $(V_IN)
	mkdir -p $(BUILD_DIR)
	yosys -q -l $(YLOG) -p '$(YS_SCRIPT)'

$(PLL_V):
	icepll -i $(CRYSTAL_MHZ) -o $(CLOCK_MHZ) -m -f $(PLL_V)
	sed -i 's/SB_PLL40_CORE/SB_PLL40_PAD/' $(PLL_V)
	sed -i 's/REFERENCECLK/PACKAGEPIN/' $(PLL_V)

clean:
	rm -f $(JSON) $(ASC) $(BIN) $(YLOG) $(NLOG)
	rmdir $(BUILD_DIR)

.PHONY: clean
