module PC(pc_out, controlePC);
	// ISA composta por 42 instruções, o contador pc contará de 0 a 41
	
	output reg [5:0] pc_out = 1'd0;
	input controlePC;
	
	always @(posedge controlePC) // Será sensível à alterações em controlePC
	begin 
	
	   if(controlePC)
		  if(pc_out<42) //considerando que façamos de 0 a 41
			   pc_out = pc_out+1;
		  else
			   pc_out = 1'd0; // Faz pc apontar para a primeira instrução novamente
			 
	end
endmodule 
