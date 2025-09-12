module nearest_neighbor (

	 input             CLK,
    input             RESET,
    input      [7:0]  PIXEL_IN,
	 
    output reg [7:0]  PIXEL_OUT,
    output reg [14:0] R_ADDR,
    output reg [16:0] W_ADDR,
    output reg        done
);

    localparam IMG_WIDTH_IN = 160;
    localparam IMG_HEIGHT_IN = 120;
	 localparam SHIFT_FACTOR = 1;
    
    // -- REGISTERS FOR FSM
	 
    reg [9:0] x_out_count, y_out_count;
    reg [16:0] write_ptr;
    reg [16:0] w_addr_sync;

    wire [9:0] IMG_WIDTH_OUT, IMG_HEIGHT_OUT;
    wire [16:0] IMG_SIZE_OUT;
    wire [8:0] x_in, y_in;
	 
	 assign IMG_WIDTH_OUT = 320;
	 assign IMG_HEIGHT_OUT = 240;
    assign IMG_SIZE_OUT   = IMG_WIDTH_OUT * IMG_HEIGHT_OUT;

    always @(posedge CLK) begin
        if (!RESET) begin
            x_out_count <= 0; y_out_count <= 0; write_ptr <= 0; done <= 1'b0;
        end else begin
            if (write_ptr >= IMG_SIZE_OUT) begin
                done <= 1'b1; write_ptr <= 0; x_out_count <= 0; y_out_count <= 0;
            end else begin
                done <= 1'b0;
                write_ptr <= write_ptr + 1;
                if (x_out_count == IMG_WIDTH_OUT - 1) begin
                    x_out_count <= 0;
                    y_out_count <= y_out_count + 1;
                end else begin
                    x_out_count <= x_out_count + 1;
                end
            end
        end
        w_addr_sync <= write_ptr; // -- SYNC READ & WRITE
    end
    
	 // -- BITWISE RIGHT SHIFT OPERATIONS
	 
    assign x_in = x_out_count >> SHIFT_FACTOR;
    assign y_in = y_out_count >> SHIFT_FACTOR;
    
    always @(*) begin
        PIXEL_OUT = PIXEL_IN;
        R_ADDR = y_in * IMG_WIDTH_IN + x_in;
        W_ADDR = w_addr_sync;
    end
endmodule