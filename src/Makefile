BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: testpattern.fs

# Synthesis
testpattern.json: testpattern.v hvsync.v rpll.v
	yosys -p "read_verilog testpattern.v; synth_gowin -top testpattern -json testpattern.json"

# Place and Route
testpattern_pnr.json: testpattern.json testpattern.cst
	nextpnr-gowin --json testpattern.json --write testpattern_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst testpattern.cst

# Generate Bitstream
testpattern.fs: testpattern_pnr.json
	gowin_pack -d ${FAMILY} -o testpattern.fs testpattern_pnr.json

# Program Board
load: testpattern.fs
	openFPGALoader -b ${BOARD} testpattern.fs

clean:
	rm -f *.json *.fs

.PHONY: load clean
