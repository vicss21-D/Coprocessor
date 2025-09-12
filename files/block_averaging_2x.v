//Modulo pra algoritmo de media de blocos para zoom out.
//Consome 4 pixels de entrada, calcula a media e gera 1 pixel de saida.
// Módulo para o algoritmo de Downscale (2X) por Média de Blocos.
// Consome 4 pixels de entrada, calcula a média e gera 1 pixel de saída.

module block_averaging_2x (
    // Entradas
    input wire clk,              // Sinal de clock
    input wire reset_n,          // Sinal de reset assíncrono (ativo baixo)
    input wire start,            // Sinal para iniciar o processo
    input wire [7:0] pixel_in,   // Pixel de 8 bits da imagem de entrada

    // Saídas
    output reg [7:0] pixel_out,     // Pixel de 8 bits da imagem de saída (média)
    output reg done,                // Sinal de conclusão
    output reg [1:0] pixel_count   // Contador para os 4 pixels lidos
);

    // Definição dos estados da FSM interna
    localparam IDLE_STATE      = 2'b00;
    localparam FETCH_PIXELS    = 2'b01;
    localparam DONE_STATE      = 2'b10;

    reg [1:0] state; // Registro para o estado atual da FSM interna
    reg [9:0] pixel_sum; // Acumulador para a soma dos 4 pixels (8 bits cada = soma máx. de 4 * 255 = 1020, que cabe em 10 bits)

    // Lógica para a FSM interna
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE_STATE;
            done <= 1'b0;
            pixel_count <= 2'b00;
            pixel_sum <= 10'b0;
        end else begin
            case (state)
                IDLE_STATE: begin
                    // Aguarda o sinal 'start'
                    if (start) begin
                        state <= FETCH_PIXELS;
                        pixel_count <= 2'b00;
                        pixel_sum <= 10'b0; // Reseta a soma
                        done <= 1'b0;
                    end
                end

                FETCH_PIXELS: begin
                    // Adiciona o pixel lido à soma
                    pixel_sum <= pixel_sum + pixel_in;
                    
                    // Incrementa o contador de pixels
                    pixel_count <= pixel_count + 1'b1;
                    
                    // Verifica se 4 pixels foram lidos
                    if (pixel_count == 2'd3) begin
                        state <= DONE_STATE;
                    end
                end

                DONE_STATE: begin
                    // Calcula a média e atribui ao pixel de saída.
                    // Divisão por 4 é um bit-shift para a direita de 2 posições.
                    pixel_out <= pixel_sum >> 2;
                    
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