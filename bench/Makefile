all:
	iverilog -o test-bench test-bench.v

sim: all
	vvp test-bench

wave: sim
	gtkwave waveform.gtkw

clean:
	rm -rf a.out waveform.vcd test-bench
