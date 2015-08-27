module Extensor(constante, palavraSaida, controle);
  
	input[1:0] controle; 
	input signed [10:0] constante;
	output reg signed [15:0]palavraSaida; 
	
	always @(controle) 
	begin 
	  
		case(controle)
		
		2'b00: begin  // loadlit c, Const
			palavraSaida[15:11] =  {5{constante[10]}};
			palavraSaida[10:0] = constante;
		end
				
		2'b01: palavraSaida = constante >> 8; // lcl c, Const8
				
		2'b10: palavraSaida = constante << 8; // lch c, Const8
			
		default: palavraSaida = 16'b0000000000000000;
				
		endcase 
	end
endmodule
