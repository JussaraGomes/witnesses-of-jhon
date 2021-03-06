/*
* @author Fábio
* Module: ULA_C
* Purpose: Ula especial para operacoes com constante. 
*/
module ULA_C (dado,constante,formato,R,resultOP);

	parameter bits_palavra = 16;

	input reg [bits_palavra-1:0] constante, dado;
	input logic [1:0] formato; // formato de operação, podendo ser carregar em um determinado byte(11) ou passar valor
	input logic R; // controle para o formato (11) carregar lcl: 0 / lch: 1
	output reg resultOP;

	always @(constante or formato or R) begin
		case (formato)
			2'b01:begin//passa valor para resultado
				resultOP = constante;
			end
			2'b11:begin
				if(R)begin//carrega na direita
					resultOP = constante | (dado & 16'b1111111100000000) ;
				end else begin//carrega na esquerda
					resultOP = (constante << 8) | (dado & 16'b0000000011111111) ;
				end
			end
			default : /* default */;
		endcase
	end
endmodule