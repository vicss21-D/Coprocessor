module zoom_controller_2 (

	input               CLK,
	input               RESET,
	input               SELECT,
	input               zoom_level_button,

	output reg   [1:0]  ALGORITHM,
	output reg   [1:0]  SHIFT_FACTOR,
   output reg   [10:0] IMG_WIDTH_OUT,
   output reg   [9:0]  IMG_HEIGHT_OUT,
	output reg   [1:0]  zoom_level
);

	localparam S_NN = 2'b00;
	localparam S_PR = 2'b01;
	localparam S_DC = 2'b10;
	localparam S_BA = 2'b11;
	
	localparam ZOOM_LEVEL_1X = 2'b00;
	localparam ZOOM_LEVEL_2X = 2'b01;
	localparam ZOOM_LEVEL_4X = 2'b10;
	localparam ZOOM_LEVEL_8X = 2'b11;
	
	localparam IMG_WIDTH_IN  = 160;
   localparam IMG_HEIGHT_IN = 120;
	
	reg zoom_level_button_d;
	wire zoom_level_button_posedge = zoom_level_button && !zoom_level_button_d;

	always @(posedge CLK or posedge RESET) begin
		if (RESET) begin
		
			zoom_level          <= ZOOM_LEVEL_1X;
         zoom_level_button_d <= 1'b0;
			
		end else begin
		
            zoom_level_button_d <= zoom_level_button;
            
            if (ALGORITHM == S_DC || ALGORITHM == S_BA) begin
				
                zoom_level <= ZOOM_LEVEL_2X;
					 
            end else if (ALGORITHM == S_NN || ALGORITHM == S_PR) begin
				
                if (zoom_level_button_posedge) begin
					 
					case(zoom_level)
					    ZOOM_LEVEL_1X: zoom_level <= ZOOM_LEVEL_2X;
					    ZOOM_LEVEL_2X: zoom_level <= ZOOM_LEVEL_4X;
					    ZOOM_LEVEL_4X: zoom_level <= ZOOM_LEVEL_8X;
					    ZOOM_LEVEL_8X: zoom_level <= ZOOM_LEVEL_2X;
					    default:       zoom_level <= ZOOM_LEVEL_2X;
					endcase
                end
            end else begin
				
                zoom_level <= ZOOM_LEVEL_1X;
            end
		end
	end

	always @(*) begin
        SHIFT_FACTOR = zoom_level;

		if ((ALGORITHM == S_NN || ALGORITHM == S_PR) && (zoom_level > ZOOM_LEVEL_1X)) begin
			IMG_WIDTH_OUT  = IMG_WIDTH_IN << SHIFT_FACTOR;
			IMG_HEIGHT_OUT = IMG_HEIGHT_IN << SHIFT_FACTOR;
		end else if ((ALGORITHM == S_DC || ALGORITHM == S_BA) && (zoom_level > ZOOM_LEVEL_1X)) begin
			IMG_WIDTH_OUT  = IMG_WIDTH_IN >> SHIFT_FACTOR;
			IMG_HEIGHT_OUT = IMG_HEIGHT_IN >> SHIFT_FACTOR;
		end else begin
			IMG_WIDTH_OUT  = IMG_WIDTH_IN;
			IMG_HEIGHT_OUT = IMG_HEIGHT_IN;
		end
	end
	
	assign ZOOM_LEVEL = zoom_level;
	
	// -- ALGORITHM SWITCH
	
	always @(posedge CLK or posedge RESET) begin
		if (RESET) begin
		
			ALGORITHM  <= S_NN;
			
		end else if (SELECT) begin
			
			case (ALGORITHM)
				
				S_NN: begin
					ALGORITHM <= S_PR;
				end
				
				S_PR: begin
					ALGORITHM <= S_DC;
				end
				
				S_DC: begin
					ALGORITHM <= S_BA;
				end
				
				S_BA: begin
					ALGORITHM <= S_NN;
				end
				
				default: begin
					ALGORITHM <= S_NN;
				end
			endcase
		end
	end

endmodule