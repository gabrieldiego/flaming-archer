`timescale 1ns/10ps

module test_bench (
  // Outputs
  clk, data
);
  output clk;
  output [7:0] data;

  reg    clk;
  reg [7:0] data;

  integer   fd;
  integer   code;
  reg [8*10:1] str;

  initial begin

    $dumpfile("waveform.vcd");
    $dumpvars(0,test_bench);

    fd = $fopen("bus_cif.yuv","r"); 
    clk = 0;
    data = 0;
    code = 1;

//    $monitor("data = %x", data);

    while (code) begin
      code = $fread(data, fd);
      @(posedge clk);
    end

    $finish;

  end // initial begin

  always #5 clk = ~clk;

endmodule // test_bench
