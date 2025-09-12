module main (

	input              CLK,
	input              RUN,
	input              RESET,
	input              ALGORITHM_SELECTOR, 
   output wire [7:0]  VGA_R,
   output wire [7:0]  VGA_G,
   output wire [7:0]  VGA_B,
   output wire        VGA_HS,
   output wire        VGA_VS,
   output wire        VGA_CLK,
   output wire        VGA_BLANK,
   output wire        VGA_SYNC
);

	// -- RESET LOGIC
	
	wire RESET_N;
	assign RESET_N = ~RESET;

	// -- INTERMEDIATE WIRES

	wire        CLK25;
	wire [7:0]  PIXEL_IN, PIXEL_OUT, RAM_PIXEL_DATA, ROM_PIXEL_DATA, PIXEL_DATA;
	wire [14:0] ROM_ADDRESS;
	wire [16:0] W_ADDR;
	wire [1:0]  IMAGE_STATE, ALGORITHM;
	wire [9:0]  NEXT_X, NEXT_Y;
	wire        CUR_COORD_STATE;
	
	// -- MODULES
	
	vga_clock vga_clock_inst (
		.CLK_IN(CLK),
		.RESET(RESET_N),
		.CLK_OUT(CLK25)
	);
	
	vga_module vga_module_inst (
		.clock(CLK25),
		.reset(RESET_N),
      .color_in(),
      .red(VGA_R),
      .green(VGA_G),
      .blue(VGA_B),
      .hsync(VGA_HS),
      .vsync(VGA_VS),
      .clk(VGA_CLK),
      .sync(VGA_SYNC),
      .blank(VGA_BLANK),
      .next_x(NEXT_X),
      .next_y(NEXT_Y)
	);
	
	// -- ASSIGN THE SUITABLE COLOR
	// ***to complete logic***
	
	assign COLOR_INFO = CUR_COORD_STATE ? PIXEL_DATA : 8'b0;
	
	vga_controller vga_controller_inst (
		.IMAGE_STATE(IMAGE_STATE),
		.X_CUR_COORD(NEXT_X),
		.Y_CUR_COORD(NEXT_Y),
		.CUR_COORD_STATE(CUR_COORD_STATE),
		.R_ADDR(ROM_ADDRESS_VGA)
	);
	
	zoom_controller (
		.CLK(CLK),
		.RESET(RESET_N),
		.SELECT(ALGORITHM_SELECTOR),
		.ALGORITHM(ALGORITHM),
		.IMAGE_STATE(IMAGE_STATE)
	);
	
	ROMInit ROMInit_inst (
		.address(ROM_ADDRESS),
		.clock(CLK),
		.q(PIXEL_IN)
	);
	
	wire [14:0] ROM_ADDRESS_VGA;
	
	ROMInit ROM_to_VGA (
		.clock(CLK),
		.address(ROM_ADDRESS_VGA),
		.q(ROM_PIXEL_DATA)
	);
	
	RAMProc RAMProc_inst (
		.clock(CLK),
		.wren(1'b1),
		.wraddress(W_ADDR),
		.data(PIXEL_OUT),
		.rdaddress(ROM_ADDRESS_VGA),
		.q(RAM_PIXEL_DATA)
	);
	
	image_processing image_processing_inst (
		.CLK(CLK),
		.RESET(RESET_N),
		.ALGORITHM(ALGORITHM),
		.PIXEL_IN(PIXEL_IN),
		.PIXEL_OUT(PIXEL_OUT),
		.R_ADDR(ROM_ADDRESS),
		.W_ADDR(W_ADDR),
		.done()
	);

endmodule