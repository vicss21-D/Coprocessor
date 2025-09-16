module display (

	input ALGORITHM,
	
	output reg [6:0] HEX1,
	output reg [6:0] HEX2,
	output reg [6:0] HEX3,
	output reg [6:0] HEX4,
	output reg [6:0] HEX5,
	output reg [6:0] HEX6
);

	localparam NN = 2'd0 ;
	localparam PR = 2'd1;
	localparam DC = 2'd2;
	localparam BA = 2'd3;

	always@(*) begin
		case (ALGORITHM)
		
			NN: begin
				HEX1 <= 7'b1001000;
				HEX2 <= 7'b1001000;
			end	
				
			PR: begin
				HEX1 <= 7'b0001100;
				HEX2 <= 7'b1001100;
			end	
				
			DC: begin
				HEX1 = 7'b1100000;
				HEX2 = 7'b1000110;
			end	
				
			BA: begin
				HEX1 = 7'b0000011;
				HEX2 = 7'b0001000;
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