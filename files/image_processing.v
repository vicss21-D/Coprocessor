module image_processing (

	input             CLK,
	input             RESET,
	input      [1:0]  ALGORITHM,
	input      [7:0]  PIXEL_IN,
	
	output reg [14:0] R_ADDR,
	output reg [7:0]  PIXEL_OUT,
	output reg [15:0] W_ADDR,
	output reg        done
);

	// -- INTERMEDIATE WIRES
	
		wire [7:0]  PIXEL_OUT_NN, PIXEL_OUT_PR, PIXEL_OUT_DC, PIXEL_OUT_BA;
		wire [14:0] R_ADDR_NN, R_ADDR_PR, R_ADDR_DC, R_ADDR_BA;
		wire [15:0] W_ADDR_NN, W_ADDR_PR, W_ADDR_DC, W_ADDR_BA;
		wire        done_NN, done_PR, done_DC, done_BA;

	// -- ALGORITHMS MODULES
	
	nearest_neighbor nn_inst (
		.CLK(CLK),
		.RESET(RESET),
		.PIXEL_IN(PIXEL_IN),
		.PIXEL_OUT(PIXEL_OUT_NN),
		.R_ADDR(R_ADDR_NN),
		.W_ADDR(W_ADDR_NN),
		.done(done_NN)
	);
	
	//pixel_replication pr_inst (
	//
	//);
	
	//decimation dc_inst (
	//
	//);
	
	//block_averaging ba_inst (
	//
	//);

	always@(*) begin
		case (ALGORITHM)
			2'd0: begin
				PIXEL_OUT = PIXEL_OUT_NN;
				R_ADDR = R_ADDR_NN;
				W_ADDR = W_ADDR_NN;
				done = done_NN;
			end
			
			2'd1: begin
				PIXEL_OUT = PIXEL_OUT_PR;
				R_ADDR = R_ADDR_PR;
				W_ADDR = W_ADDR_PR;
				done = done_PR;
			end
			
			2'd2: begin
				PIXEL_OUT = PIXEL_OUT_PR;
				R_ADDR = R_ADDR_PR;
				W_ADDR = W_ADDR_PR;
				done = done_PR;
			end
				
			2'd3: begin
				PIXEL_OUT = PIXEL_OUT_BA;
				R_ADDR = R_ADDR_BA;
				W_ADDR = W_ADDR_BA;
				done = done_BA;
			end
		endcase
	end
endmodule