// Módulo para o algoritmo de Zoom In (2X) com Vizinho Mais Próximo.
// A lógica para 2X é idêntica à replicação de pixel, pois o pixel mais
// próximo de um bloco 2x2 na imagem de saída é sempre o pixel original.

module nearest_neighbor_zoom_2x (
    // Entradas
    input wire clk,              // Sinal de clock
    input wire reset_n,          // Sinal de reset assíncrono (ativo baixo)
    input wire start,            // Sinal para iniciar o processo
    input wire [7:0] pixel_in,   // Pixel de 8 bits da imagem de entrada

    // Saídas
    output reg [7:0] pixel_out,     // Pixel de 8 bits da imagem de saída
    output reg done,                // Sinal de conclusão
    output reg [1:0] pixel_count   // Contador para os 4 pixels de saída
);

    // Definição dos estados da FSM interna
    localparam IDLE_STATE      = 2'b00;
    localparam GENERATE_PIXEL  = 2'b01;
    localparam DONE_STATE      = 2'b10;

    reg [1:0] state; // Registro para o estado atual da FSM interna

    // Lógica para a FSM interna
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE_STATE;
            done <= 1'b0;
            pixel_count <= 2'b00;
        end else begin
            case (state)
                IDLE_STATE: begin
                    // Aguarda o sinal 'start' do módulo de controle principal
                    if (start) begin
                        state <= GENERATE_PIXEL;
                        pixel_count <= 2'b00;
                        done <= 1'b0;
                    end
                end

                GENERATE_PIXEL: begin
                    // Atribui o pixel de entrada ao pixel de saída.
                    // Em um zoom 2X, o pixel mais próximo de qualquer ponto
                    // dentro de um bloco 2x2 é o pixel original.
                    pixel_out <= pixel_in;

                    // Incrementa o contador de pixels
                    pixel_count <= pixel_count + 1'b1;

                    // Verifica se os 4 pixels foram gerados
                    if (pixel_count == 2'd3) begin
                        state <= DONE_STATE;
                    end
                end

                DONE_STATE: begin
                    // Sinaliza que o processo está completo e retorna para IDLE
                    done <= 1'b1;
                    state <= IDLE_STATE;
                end

                default: begin
                    state <= IDLE_STATE;
                end
            endcase
        end
    end
    
endmodule