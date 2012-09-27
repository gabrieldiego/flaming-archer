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

  reg [11:0] stride;
  reg [11:0] width;
  reg [11:0] height;

  reg setup_frame;

  initial begin

    $dumpfile("waveform-frame-buffer.vcd");
    $dumpvars(0,test_bench);

    fd = $fopen("bus_cif.yuv","r"); 
    clk = 0;
    data = 0;
    code = 1;

//    $monitor("data = %x", data);

    @(posedge clk);
    setup_frame = 1;
    stride = 2048;
    width = 1920;
    height = 1080;

    @(posedge clk);
    setup_frame = 0;
    stride = 0;
    width = 0;
    height = 0;

    while (code) begin
      code = $fread(data, fd);
      @(posedge clk);
    end

    $finish;

  end // initial begin

  always #5 clk = ~clk;

  frame_buffer #(.MEM_WIDTH(64)) test_frame_buffer (
    .clk(clk), .setup_frame(setup_frame),
    .stride_in(stride), .width_in(width), .height_in(height)
  );

endmodule // test_bench
