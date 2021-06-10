TOP_MOD=exp01
V_IN=$(TOP_MOD).v
JSON_OUT=$(TOP_MOD).json

all: $(V_IN)
	yosys -p 'read_verilog $(V_IN); synth_ice40 -json $(JSON_OUT)'
	nextpnr-ice40 --up5k --package sg48 --json $(JSON_OUT)

clean:
	rm $(JSON_OUT)

.PHONY: clean
