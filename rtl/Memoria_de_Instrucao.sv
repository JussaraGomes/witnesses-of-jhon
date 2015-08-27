module Memoria_de_Instrucao(clk_MI, reset, pc, instrucao);
	 
	parameter num_registros = 6; // 42 instruções 6 bits
	
	input clk_MI, reset;
	input [5:0] pc;
	output reg [15:0] instrucao;
	
	reg [15:0] reg_instrucao [num_registros-1:0];	
	
	initial // Bloco para fins de teste
		begin
			reg_instrucao[0] = 16'b1100110011001100;
			reg_instrucao[1] = 16'b1100111010101111;
			reg_instrucao[1] = 16'b0100010101000101; // São 42 instruções
		end
	
	always@(posedge clk_MI, posedge reset) 
		begin
			if(reset) //Reset assíncrono
				begin 
					reg_instrucao[0] = 16'b1010110011001010;
					reg_instrucao[1] = 16'b1111000011110000; // ... 42
				end
			instrucao = reg_instrucao[pc]; // Atualiza a saída
		end	 
endmodule
