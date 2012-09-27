MODULES=frame-buffer
TEST_BENCHS=$(addprefix test-bench-,$(MODULES))
WAVEFORMS=$(addsuffix .vcd,$(addprefix waveform-,$(MODULES)))

all: sim

benchs: $(TEST_BENCHS)

test-bench-%:
	iverilog -o $@ $@.v ../rtl/*.v

sim: $(WAVEFORMS)

waveform-%.vcd: test-bench-%
	vvp $<

waveform-%: waveform-%.vcd
	gtkwave $@.gtkw

clean:
	rm -rf $(WAVEFORMS) $(TEST_BENCHS)
