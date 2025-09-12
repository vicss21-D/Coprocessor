module vga_top (
    input wire         CLOCK_50,
    input wire         RESET,
    input wire  [7:0]  SW,
    output wire [7:0]  VGA_R,
    output wire [7:0]  VGA_G,
    output wire [7:0]  VGA_B,
    output wire        VGA_HS,
    output wire        VGA_VS,
    output wire        VGA_CLK,
    output wire        VGA_BLANK,
    output wire        VGA_SYNC
);

    wire reset_n;
    reg  vga_clk = 1'b0;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire [7:0] colors;
    wire [7:0] lists;
	 
    assign reset_n = ~RESET;

    always @(posedge CLOCK_50 or posedge reset_n) begin
        if (reset_n) begin
            vga_clk <= 1'b0;
        end else begin
            vga_clk <= ~vga_clk;
        end
    end

    lists lists_inst (
        .X_COORD(pixel_x),
        .SW(SW),
        .COLOR_OUT(lists)
    );

    vga_module vga_module_inst (
        .clock(vga_clk),
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
        .next_x(pixel_x),
        .next_y(pixel_y)
    );

endmodule