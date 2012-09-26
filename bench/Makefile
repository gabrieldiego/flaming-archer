all: test-bench

test-bench:
	iverilog -o test-bench test-bench.v

sim: waveform.vcd

waveform.vcd: test-bench
	vvp test-bench

wave: sim
	gtkwave waveform.gtkw

clean:
	rm -rf a.out waveform.vcd test-bench
