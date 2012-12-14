`timescale 1ns/10ps

module test_bench (
  // Outputs
  clk, data
);
  parameter FRAME_WIDTH  = 352;
  parameter FRAME_HEIGHT = 288;
  parameter FRAME_STRIDE = FRAME_WIDTH;
  parameter FRAME_SIZE   = FRAME_WIDTH*FRAME_HEIGHT;

  output clk;
  output [63:0] data;

  reg         clk;
  reg         reset;
  reg [63:0]  data;

  integer     fd;
  integer     code;
  integer     i;

  reg [11:0]  stride;
  reg [11:0]  width;
  reg [11:0]  height;

  reg         setup_frame;

  reg [10:0]  x,y;
  reg [31:0]  file_pos;

  reg [FRAME_SIZE*8-1:0] frame_buffer;

  wire        mem_addr;
  wire        mem_data;

  reg         fb_write;
  reg  [63:0] fb_data;

  initial begin

    $dumpfile("waveform-frame-buffer.vcd");
    $dumpvars(0,test_bench);

    fd = $fopen("bus_cif.yuv","r"); 
    clk = 0;
    data = 0;
    reset = 1;
    code = 1;
    setup_frame = 0;

    @(posedge clk);
    reset = 0;

    /* Setup the parameters of the frame buffer */
    stride = FRAME_WIDTH;
    width  = FRAME_WIDTH;
    height = FRAME_HEIGHT;
    file_pos = 0;

    @(posedge clk);
    setup_frame = 1;

    /* Possible bug in iverilog? */
    @(posedge clk);
    @(negedge clk);
    setup_frame = 0;

    @(posedge clk);
    setup_frame = 0;
    stride = 0;
    width = 0;
    height = 0;

    code = $fread(frame_buffer, fd);

    if(!code) begin
      $write("Error reading file.");
      $finish;
    end

    file_pos = 0;

    fb_write = 1;
    @(posedge clk);

    /* Loop over the input pixels */
    while (file_pos != FRAME_SIZE) begin
      for(i=0; i<8*8; i=i+1) begin
        fb_data[i] = frame_buffer[file_pos+i];
      end

      @(posedge clk);

      file_pos = file_pos+8*8;
      
    end

    $finish;

  end // initial begin

  always #1 clk = ~clk;

  frame_buffer #(.MEM_WIDTH(64)) test_frame_buffer (
    .clk(clk), .reset(reset), .x(x), .y(y),
    .fb_write(fb_write), .fb_data(fb_data), .setup_frame(setup_frame),
    .stride_in(stride), .width_in(width), .height_in(height)
  );

endmodule // test_bench
