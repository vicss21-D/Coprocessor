module resolution_controller (

	input                CLK,
	input                RESET,
	input                zoom_level_button,  
	input         [1:0]  ALGORITHM,          

	output reg    [1:0]  SHIFT_FACTOR,       
   output reg    [10:0] IMG_WIDTH_OUT,      
   output reg    [9:0]  IMG_HEIGHT_OUT
);

	// -- PARAMETERS
	
	localparam S_NN = 2'b00; // Nearest Neighbor 
	localparam S_PR = 2'b01; // Pixel Replication 
	localparam S_DC = 2'b10; // Decimation 
	localparam S_BA = 2'b11; // Block Averaging 
	

	localparam ZOOM_LEVEL_1X = 2'b00; // 1x
	localparam ZOOM_LEVEL_2X = 2'b01; // 2x
	localparam ZOOM_LEVEL_4X = 2'b10; // 4x
	localparam ZOOM_LEVEL_8X = 2'b11; // 8x
	
	localparam IMG_WIDTH_IN  = 160;
   localparam IMG_HEIGHT_IN = 120;
	
	reg [1:0] zoom_level; 
	
	// Lógica para detecção de borda do botão de zoom
	
	reg zoom_level_button_d;
	wire zoom_level_button_posedge = zoom_level_button && !zoom_level_button_d;

	//

	always @(posedge CLK or posedge RESET) begin
	
		if (RESET) begin
		
				zoom_level          <= ZOOM_LEVEL_1X; 
            zoom_level_button_d <= 1'b0;
				
		end else begin
            
            zoom_level_button_d <= zoom_level_button;
            
            
            if ((ALGORITHM == S_DC || ALGORITHM == S_BA) && (zoom_level > ZOOM_LEVEL_2X)) begin
                zoom_level <= ZOOM_LEVEL_1X;
            
            
            end else if (zoom_level_button_posedge) begin
				if (ALGORITHM == S_NN || ALGORITHM == S_PR) begin
                    
					if(zoom_level == ZOOM_LEVEL_8X)
						zoom_level <= ZOOM_LEVEL_1X;
					else
						zoom_level <= zoom_level + 1;

				end else if (ALGORITHM == S_DC || ALGORITHM == S_BA) begin
                    
                    if (zoom_level == ZOOM_LEVEL_1X)
                        zoom_level <= ZOOM_LEVEL_2X;
                    else
                        zoom_level <= ZOOM_LEVEL_1X;
				end
			end
		end
	end

	// -- CL
	
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

endmodule