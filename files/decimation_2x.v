// Módulo para o algoritmo de Downscale (2X) por Decimação.
// Consome 4 pixels de entrada e gera 1 pixel de saída.

module decimation_2x (
    // Entradas
    input wire clk,             // Sinal de clock
    input wire reset_n,         // Sinal de reset assíncrono (ativo baixo)
    input wire start,           // Sinal para iniciar o processo de decimação
    input wire [7:0] pixel_in,  // Pixel de 8 bits da imagem de entrada

    // Saídas
    output reg [7:0] pixel_out,     // Pixel de 8 bits da imagem de saída (decimado)
    output reg done,                // Sinal de conclusão
    output reg [1:0] pixel_count   // Contador para os 4 pixels lidos
);

    // Definição dos estados da FSM interna
    localparam IDLE_STATE      = 2'b00;
    localparam FETCH_PIXELS    = 2'b01;
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
                        state <= FETCH_PIXELS;
                        pixel_count <= 2'b00;
                        done <= 1'b0;
                    end
                end

                FETCH_PIXELS: begin
                    // Lógica para ler 4 pixels do bloco 2x2
                    // A cada pulso de clock, lemos um pixel de entrada.
                    pixel_count <= pixel_count + 1'b1;
                    
                    // No último pixel do bloco (o 4º pixel, count = 3),
                    // geramos o pixel de saída. Vamos usar o primeiro pixel lido
                    // como o pixel de saída (estratégia de decimação).
                    // Para isso, precisamos armazenar o primeiro pixel em um registrador.
                    // Para simplicidade inicial, vamos considerar que o 'pixel_in'
                    // já é o pixel do canto superior esquerdo.
                    if (pixel_count == 2'd0) begin
                        pixel_out <= pixel_in;
                    end

                    // Verifica se 4 pixels foram lidos
                    if (pixel_count == 2'd3) begin
                        state <= DONE_STATE; // Transiciona para o estado 'DONE'
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