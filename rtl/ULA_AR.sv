/*
* @author Fábio
* Module: ULA_AR
* Purpose: Ula que realiza somente operaçoes aritimeticas
*/
module ULA_AR (
	A,
	B,
	OP,
	RESU,
	O,
	C,
	S,
	Z
);
	parameter bits=3;

	input reg signed [bits-1:0] A,B;	//dados para operacao
	input reg [4:0] OP;					//tipo de operacao
	output reg signed [bits-1:0] RESU;	//resultado da operacao
	output logic 	O,					//flag que indica se ouve overflow na operacao
					C,					//flag que indica se ouve carryout na operacao
					S,					//flag que indica o sinal do resultado da operacao
					Z;					//flag que indica que o resultado da operacao é Zero
	logic [bits+1:0] AUX;				//Auxilia na identificação de carry e overflow

	always @(A or B or OP) begin
		case (OP)
			5'b00000: AUX = A+B;
			5'b00001: AUX = A+B+1;
			5'b00011: AUX = A+1;
			5'b00100: AUX = A-B-1;
			5'b00101: AUX = A-B;
			5'b00110: AUX = A-1;
			default : ;
		endcase
		RESU = AUX;
		case (OP[2:1])
			2'b00:if((A[bits-1] == B[bits-1]) && (RESU[bits-1] != A[bits-1]))
					O = 1;
				else
					O = 0;
			2'b10:if((A[bits-1] != B[bits-1]) && (RESU[bits-1] != A[bits-1])) 
					O = 1;
				else
					O = 0;
			2'b11:if((A[bits-1]) && (RESU[bits-1] != A[bits-1]))
					O = 1;
				else
					O = 0;					
			2'b01:if((!A[bits-1]) && (RESU[bits-1] != A[bits-1]))
					O = 1;
				else
					O = 0;
			default:  
				O = 0;	
		endcase
		S = RESU [bits-1];
		if(!RESU)
			Z = 1;
		else
			Z = 0;
		if(Z == 1 && (A == ~B+1 || OP == 5'b00001 || OP == 5'b00100))
			C = 1;
		else
			C = AUX[bits];
		if (!C)
			C = AUX[bits+1];
	end
endmodule