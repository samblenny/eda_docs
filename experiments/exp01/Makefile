TOP_MOD=exp01
V_IN=$(TOP_MOD).v
JSON=$(TOP_MOD).json
ASC=$(TOP_MOD).asc
BIN=$(TOP_MOD).bin
PKG=--up5k --package sg48
PLL_V=pll.v
PCF=ice40up5k-b-evn.pcf
PRE_PACK=pre_pack.py
CRYSTAL_MHZ=12
CLOCK_MHZ=24


$(BIN): $(ASC)
	icepack $(ASC) $(BIN)

prog: $(BIN)
	iceprog $(BIN)

$(ASC): $(JSON) $(PCF) $(PRE_PACK)
	nextpnr-ice40 $(PKG) --pcf $(PCF) --pre-pack $(PRE_PACK) --json $(JSON) --asc $(ASC)

$(JSON): $(PLL_V) $(V_IN)
	yosys -q -p 'read_verilog $(V_IN); synth_ice40 -top $(TOP_MOD) -json $(JSON)'

$(PLL_V):
	icepll -i $(CRYSTAL_MHZ) -o $(CLOCK_MHZ) -m -f $(PLL_V)
	sed -i 's/SB_PLL40_CORE/SB_PLL40_PAD/' $(PLL_V)
	sed -i 's/REFERENCECLK/PACKAGEPIN/' $(PLL_V)

clean:
	rm -f $(JSON) $(ASC) $(BIN)

.PHONY: clean
