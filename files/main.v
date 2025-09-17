module main (

	input          CLK,
	input          RUN,
	input          RESET,
	input          ALGORITHM_SELECTOR, 
	
   output  [7:0]  VGA_R,
   output  [7:0]  VGA_G,
   output  [7:0]  VGA_B,
   output         VGA_HS,
   output         VGA_VS,
   output         VGA_CLK,
   output         VGA_BLANK,
   output         VGA_SYNC,
	
	output  [6:0]  HEX1,
	output  [6:0]  HEX2,
	output  [6:0]  HEX3,
	output  [6:0]  HEX4,
	output  [6:0]  HEX5,
	output  [6:0]  HEX6
);

	// -- RESET LOGIC
	
	wire RESET_N;
	assign RESET_N = ~RESET;

	// -- INTERMEDIATE WIRES

	wire        CLK25, CLK1;
	wire [7:0]  PIXEL_IN, PIXEL_OUT, RAM_PIXEL_DATA, ROM_PIXEL_DATA, PIXEL_DATA, COLOR_INFO;
	wire [14:0] ROM_ADDRESS;
	wire [16:0] W_ADDR, VGAR_ADDR;
	wire [1:0]  IMAGE_STATE, ALGORITHM;
	wire [9:0]  NEXT_X, NEXT_Y;
	wire        CUR_COORD_STATE;
	
	// -- MODULES
	
	vga_clock vga_clock_inst (
		.CLK_IN(CLK),
		.RESET(RESET_N),
		.CLK_OUT_25(CLK25),
		.CLK_OUT_1(CLK1)
	);
	
	vga_module vga_module_inst (
		.clock(CLK25),
		.reset(RESET_N),
      .color_in(COLOR_INFO), //ROM_PIXEL_DATA, RAM_PIXEL_DATA
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
	
	
	assign COLOR_INFO = CUR_COORD_STATE ? RAM_PIXEL_DATA : 8'b0;
	
	vga_controller vga_controller_inst (
		.IMAGE_STATE(IMAGE_STATE),
		.X_CUR_COORD(NEXT_X),
		.Y_CUR_COORD(NEXT_Y),
		.CUR_COORD_STATE(CUR_COORD_STATE),
		.R_ADDR(VGAR_ADDR)
	);
	
	zoom_controller (
		.CLK1(CLK1),
		.CLK(CLK),
		.RESET(RESET_N),
		.SELECT(ALGORITHM_SELECTOR),
		.zoom_requested(1'b1), // given by main FSM
		.ALGORITHM(ALGORITHM),
		.IMAGE_STATE(IMAGE_STATE)
	);
	
	// test a single ROM block

	
	ROMInit ROMInit_inst (
		.address(ROM_ADDRESS),
		.clock(CLK),
		.q(PIXEL_IN)
	);
	
	// test a single ROM block
	
	ROMInit ROM_to_VGA (
		.clock(CLK),
		.address(VGAR_ADDR[14:0]),
		.q(ROM_PIXEL_DATA)
	);
	
	RAMProc RAMProc_inst (
		.clock(CLK),
		.wren(1'b1), // link with the main FSM 
		.wraddress(W_ADDR),
		.data(PIXEL_OUT),
		.rdaddress(VGAR_ADDR),
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
		.done() // link with the main FSM
	);
	
	display display_inst(
		.ALGORITHM(ALGORITHM),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6)
	);

endmodule