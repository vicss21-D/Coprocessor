module vga_clock (

	input wire  CLK_IN,
	input wire  RESET,
	output reg  CLK_OUT_25,
	output reg  CLK_OUT_1
);
	
	reg [24:0] counter = 0;
	
	localparam MAX_COUNT = 25000000 - 1;

   always @(posedge CLK_IN or posedge RESET) begin
	 
		if (RESET) begin
          CLK_OUT_25 <= 1'b0;
      end else begin
          CLK_OUT_25 <= ~CLK_OUT_25;
      end
   end
	 
	 always @(posedge CLK_IN or posedge RESET) begin
			
			if (RESET) begin
				counter <= 0;
				CLK_OUT_1 <= 0;
				
			end else begin
				if (counter == MAX_COUNT) begin
					counter <= 0;
					CLK_OUT_1 <= ~CLK_OUT_1;
				end else begin
					counter <= counter + 1;
				end
			end
	 end
	 
endmodule