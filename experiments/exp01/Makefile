TOP_MOD=exp01
V_IN=$(TOP_MOD).v
JSON=$(TOP_MOD).json
ASC=$(TOP_MOD).asc
PKG=--up5k --package sg48
PLL_V=pll.v
PCF=ice40up5k-b-evn.pcf
CRYSTAL_MHZ=12
CLOCK_MHZ=24

all: pll synth $(PCF) $(JSON)
	nextpnr-ice40 $(PKG) --pcf $(PCF) --pcf-allow-unconstrained --json $(JSON) --asc $(ASC)

synth: $(V_IN) pll
	yosys -q -p 'read_verilog $(V_IN); synth_ice40 -top $(TOP_MOD) -json $(JSON)'

pll: $(PLL_V)
	icepll -i $(CRYSTAL_MHZ) -o $(CLOCK_MHZ) -m -f $(PLL_V)

clean:
	rm -f $(JSON) $(ASC)

.PHONY: clean
