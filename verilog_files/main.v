module main(

	input              CLK,
	input              RESET,
   output wire [7:0]  VGA_R,
   output wire [7:0]  VGA_G,
   output wire [7:0]  VGA_B,
   output wire        VGA_HS,
   output wire        VGA_VS,
   output wire        VGA_CLK,
   output wire        VGA_BLANK,
   output wire        VGA_SYNC
);

	wire clk25;
	
	vga_clock vga_clock_inst (
		.CLK_IN(CLK),
		.RESET(RESET),
		.CLK_OUT(clk25)
	);
	
	wire [14:0] address;
	
	ROMInit ROMInit_inst (
		address(address),
		clock(CLK),
		q()
	);

	vga_module vga_module_inst (
		.clock(clk25),
		.reset(reset_n),
      .color_in(lists),
      .red(VGA_R),
      .green(VGA_G),
      .blue(VGA_B),
      .hsync(VGA_HS),
      .vsync(VGA_VS),
      .clk(VGA_CLK),
      .sync(VGA_SYNC),
      .blank(VGA_BLANK),
      .next_x(address_a),
      .next_y(address_b)
	);

endmodule