// Algoritmo de zoom in (2x) por replicaçao de pixel


module pixel_replication_2x (
	//entradas da funçao
	input wire clk,
	input wire reset_n,
	input wire start,
	input wire [7:0] pixel_i,  //pixel de 8 bits na imagem de entrada
	
	//saidas
	output red [7:0] pixel_out,  //pixel de 8 bits da iamgem de saida
	output reg done,  //sinal de conclusao
	output reg [1:0] pixel_count, //contador par os 4 pixels de saida

);

	//Definiçao dos estados da FSM interna
	localparam IDLE_STATE = 2'b00; //estado de espera
	localparam GENERATE_PIXEL = 2'b01; //gerando os 4 pixels
	localparam  DONE_STATE = 2'b10; //processo finalizado
	
	reg [1:0] state; //registro para o estado atual da fsm interna
	
	//logica para a fsm interna
	always @(posedge clk or nedge reset_n) begin
		if (!reset_n) begin
			state <+ IDLE_STATE;
			done <= 1'b0;
			pixel_count<= 2'b00;
		end else begin
			case (state)
				IDLE_STATE: begin //aguarda o sinal 'start' do modulo de controle principal
					if (start) begin
						state<= GENERATE_PIXEL;
						pixel_count <= 2'b00
						done <= 1'b0;
					end
				end
				GENERATE_PIXEL: Begin  //logica para gerar os 4 pixels
					pixel_out <= pixel_in  //o pixel de saida e sempre o mesmo de entrada
					//incrementa o contador de pixels
					pixel_count <= pixel_count + 1'b1;
					//verifica se os 4 pixels foram gerados
					if (pixel_count == 2'd3) begin
						state <= DONE_STATE //transiciona para 'done'
					end
				end
				DONE_STATE: begin //sinaliza que o processo esta completo e retorna para IDLE
					done <= 1'b1;
					state <= IDLE_STATE;
				end
				default: beginn
					state <= IDLE_STATE;
				end
			endcase
		end
	end
endmodule
						
	