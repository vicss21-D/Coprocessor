module vga_clock (

	input wire  CLK_IN,
	input wire  RESET,
	output reg  CLK_OUT
);

	 wire reset_n;
    assign reset_n = ~RESET;

    always @(posedge CLK_IN or posedge reset_n) begin
        if (reset_n) begin
            CLK_OUT <= 1'b0;
        end else begin
            CLK_OUT <= ~CLK_OUT;
        end
    end

endmodule