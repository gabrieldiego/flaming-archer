module frame_buffer (
  clk,reset,

  // Interface with memory
  mem_addr,
  mem_data,
  mem_data_out,
  mem_read,
  mem_write,

  // Pixel loader
  x,y,
  read_block,
  blk_line,
  blk_line_rdy,

  fb_write,
  fb_data,

  // Frame setup
  stride_in,
  width_in,
  height_in,
  setup_frame

);
  parameter MEM_WIDTH=64;
  parameter BLK_WIDTH=8;

  input clk,reset;

  output [20:0] mem_addr; // Output address to the memory block
  input  [MEM_WIDTH-1:0] mem_data; // Input data from the memory block
  output [MEM_WIDTH-1:0] mem_data_out; // Output data to the memory block
  output mem_read;      // Signal to read from the memory
  output mem_write;     // Signal to write to the memory

  input  [10:0] x,y;    // Block x and y position to be read
  input  read_block;    // Pulse to send block position and start reading
                        // block data
  output [BLK_WIDTH*8-1:0] blk_line; // Load an entire line at each cycle
  output blk_line_rdy;  // Pixel line ready to be read

  input  fb_write;      // Pulse to send a entire frame buffer
  input  [BLK_WIDTH*8-1:0] fb_data; // Data to the frame buffer

  // Input of the measures of the frame
  input  [11:0] stride_in;
  input  [11:0] width_in;
  input  [11:0] height_in;
  input  setup_frame;

  reg [11:0] stride;
  reg [11:0] width;
  reg [11:0] height;

  reg [20:0] mem_addr;
  reg [MEM_WIDTH-1:0] mem_data_out;
  reg mem_write;

  reg [10:0] x_pos,y_pos;

  always @ (posedge clk) begin
    if(setup_frame == 1) begin
      stride = stride_in;
      width = width_in;
      height = height_in;
    end
    else if(fb_write == 1) begin
      x_pos = 0;
      y_pos = 0;

      /* Receive the first line of pixels just in the next cycle */
      while(y_pos != height) begin
        mem_addr = (x_pos + y_pos * stride) * 8;
        mem_data_out = fb_data;
        mem_write = "1";
        if(x_pos != width) begin
          x_pos = x_pos + BLK_WIDTH;
        end else begin
          x_pos = 0;
          y_pos = y_pos + 1;
        end
        @(posedge clk);
      end
    end
  end

endmodule // frame_buffer
