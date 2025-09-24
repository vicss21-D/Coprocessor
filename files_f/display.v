module display (

	input      [1:0] ALGORITHM,
	
	output reg [6:0] HEX0,
	output reg [6:0] HEX1,
	output reg [6:0] HEX2,
	output reg [6:0] HEX3,
	output reg [6:0] HEX4,
	output reg [6:0] HEX5
);

	localparam NN = 2'd0;
	localparam PR = 2'd1;
	localparam DC = 2'd2;
	localparam BA = 2'd3;
	
	// HEX3 - 1st digit
	// HEX2 - 2nd digit

	always@(*) begin
		case (ALGORITHM)
		
			NN: begin
				HEX5 <= 7'b1111111;
				HEX4 <= 7'b1111111;
				HEX3 <= 7'b1001000;
				HEX2 <= 7'b1001000;
				HEX1 <= 7'b1111111;
				HEX0 <= 7'b1111111;
			end	
				
			PR: begin
				HEX5 <= 7'b1111111;
				HEX4 <= 7'b1111111;
				HEX3 <= 7'b1001100;
				HEX2 <= 7'b0001100;
				HEX1 <= 7'b1111111;
				HEX0 <= 7'b1111111;
			end	
				
			DC: begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = 7'b1000110;
				HEX2 = 7'b1100000;
				HEX1 = 7'b1111111;
				HEX0 = 7'b1111111;
			end	
				
			BA: begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = 7'b0000011;
				HEX2 = 7'b0000011;
				HEX1 = 7'b1111111;
				HEX0 = 7'b1111111;
			end	
				
			default: begin
				HEX1 = 7'b1111111;
				HEX2 = 7'b1111111;
				HEX3 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX5 = 7'b1111111;
				HEX6 = 7'b1111111;
			end
		endcase
	end
endmodule