module frame_buffer (
  clk,reset,

  // Interface with memory
  out_addr,
  in_data,

  // Pixel loader
  x,y,
  read_block,
  blk_line,
  blk_line_rdy,

  // Frame setup
  stride_in,
  width_in,
  height_in,
  setup_frame

);
  parameter MEM_WIDTH=64;

  input clk,reset;

  // TODO: What is the bit width of the memory access?
  //  A: Don't bother with that now and use 64 as a stopgap.
  output [20:0] out_addr; // Output address to the memory block
  input  [MEM_WIDTH-1:0] in_data;  // Input data from the memory block

  input  [10:0] x,y;    // Block x and y position to be read
  input  read_block;    // Pulse to send block position and start reading
                        // block data
  output [127:0] blk_line;      // Load an entire line at each cycle
  output blk_line_rdy;  // Pixel line ready to be read

  input  [11:0] stride_in;
  input  [11:0] width_in;
  input  [11:0] height_in;
  input  setup_frame;

  reg [11:0] stride;
  reg [11:0] width;
  reg [11:0] height;

  always @ (posedge clk) begin
    if(setup_frame == 1) begin
      stride = stride_in;
      width = width_in;
      height = height_in;
    end
  end

endmodule // frame_buffer
