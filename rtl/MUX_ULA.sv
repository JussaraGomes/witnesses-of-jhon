module MUX_ULA(entrada_BR, entrada_EX, saida_Mux, controle);
  input controle;
  input [15:0] entrada_BR, entrada_EX; 
  output reg [15:0] saida_Mux; 
  
 	always_comb 
	begin
		if(controle == 1'b0) // Seleciona entrada Banco de Registros
		  saida_Mux = entrada_BR;
		else if(controle == 1'b1) // Seleciona entrada Extensor Sinal
		  saida_Mux = entrada_EX;	
	end
endmodule
