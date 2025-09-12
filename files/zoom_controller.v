module zoom_controller (

	input CLK,
	input RESET,
	input SELECT,
	
	output reg [1:0] ALGORITHM,
	output reg [1:0] IMAGE_STATE
);
	
	localparam S_NN = 2'd0;
	localparam S_PR = 2'd1;
	localparam S_DC = 2'd2;
	localparam S_BA = 2'd3;

	always @(posedge CLK or posedge RESET) begin
		if (RESET) begin
		
			ALGORITHM  <= S_NN;
			
		end else if (!SELECT) begin
			
			if (ALGORITHM == S_NN) begin
				ALGORITHM <= S_PR;
			end else if (ALGORITHM == S_PR) begin
				ALGORITHM <= S_DC;
			end else if (ALGORITHM == S_DC) begin
				ALGORITHM <= S_BA;
			end else if (ALGORITHM == S_BA) begin
				ALGORITHM <= S_NN;
			end
		end
	end
	
	localparam S_DEFAULT  = 2'd0;
	localparam S_ENLARGED = 2'd1;
	localparam S_REDUCED  = 2'd2;
	
	// ***adjust if-else logic***
	
	always @(posedge CLK or posedge RESET) begin
		if (RESET) begin
			IMAGE_STATE <= S_DEFAULT;
			
		end else if (!SELECT) begin
			
			if ((ALGORITHM == S_NN || ALGORITHM == S_PR) && IMAGE_STATE == S_DEFAULT)           begin
				IMAGE_STATE <= S_ENLARGED;
			end else if ((ALGORITHM == S_NN || ALGORITHM == S_PR) && IMAGE_STATE == S_ENLARGED) begin
				IMAGE_STATE <= S_ENLARGED;
			end else if ((ALGORITHM == S_NN || ALGORITHM == S_PR) && IMAGE_STATE == S_REDUCED)  begin
				IMAGE_STATE <= S_DEFAULT;
			end else if ((ALGORITHM == S_DC || ALGORITHM == S_BA) && IMAGE_STATE == S_DEFAULT)  begin
				IMAGE_STATE <= S_REDUCED;
			end else if ((ALGORITHM == S_DC || ALGORITHM == S_BA) && IMAGE_STATE == S_ENLARGED) begin
				IMAGE_STATE <= S_DEFAULT;
			end else if ((ALGORITHM == S_DC || ALGORITHM == S_BA) && IMAGE_STATE == S_REDUCED)  begin
				IMAGE_STATE <= S_REDUCED;
			end
	   end
	end

endmodule