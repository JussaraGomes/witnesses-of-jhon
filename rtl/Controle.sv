include "Clock.sv";
include "PC.sv";  // PC
include "Memoria_de_Instrucao.sv";  // Memoria_de_Instrucao
include "BR.sv";
include "ES.sv"; 
include "MUX_ULA.sv";


module Controle(instrucao, botao);
  input botao; 
	input reg [15:0]instrucao;
	reg [2:0] estado = 3'b000, prox_estado = 3'b000;	
	
	//------------------------------------------ 1º CICLO
	logic controlePC;
	
	//------------------------------------------ 2º CICLO
  parameter end_registros = 2; // Quantidade de bits necessários para endereçar os registros, atualmente 4 registro

  logic [15:0] BR_Entrada;
  logic [end_registros-1:0] BR_Sel_E_SA, BR_Sel_SB; 
  logic BR_Hab_Escrita, BR_reset;
	reg [1:0] controleEX; 
	logic [10:0] EX_constante;
 	  
	//------------------------------------------ 3º CICLO
	logic controleMUX_ULA;
	
	Clock Clock (); 
	PC PC(.controlePC(controlePC));
	Memoria_de_Instrucao Memoria_de_Instrucao(.clk_MI(Clock.clk), .pc(PC.pc_out)); 
	BR Banco_Registro(.Hab_Escrita(BR_Hab_Escrita), .Sel_E_SA(BR_Sel_E_SA), .Sel_SB(BR_Sel_SB), .reset(BR_reset), .clock(Clock.clk), .E(BR_Entrada));
  ES Extensor(.controle(controleEx), .constante(EX_constante));
	MUX_ULA MUX_ULA(.entrada_BR(Banco_Registro.B), .entrada_EX(Extensor.palavraSaida), .controle(controleMUX_ULA));
	
	always
	 estado <= prox_estado; 
	
	always @(estado)
	begin
	  case(estado)
	     
	    3'b000: begin // Leitura da instrução a ser executada. ******************************************************************
	      if(botao) begin	         
		       instrucao = Memoria_de_Instrucao.instrucao;
		       controlePC = 1'b1;
	         prox_estado = 3'b001; 
	        end  
	       end
	    
	    3'b001: begin // A instrução é decodificada e os operandos são lidos do banco de registradores *************************
	      if(instrucao[15:14] == 2'b10) begin // Caso instução Lógicas Aritméticas 
	         BR_Hab_Escrita = 1'b0; // Certifica de desabilitar Escrita
	         BR_Sel_E_SA = instrucao[5:3]; // Seleciona Op A
	         BR_Sel_SB = instrucao[2:0]; // Seleciona Op B
	      end  
	      
	      else if(instrucao[15:14] == 2'b01) begin // Caso instução Formato I 
	         controleEX = 2'b00;
	         EX_constante = instrucao[10:0];  
	      end else if(instrucao[15:14] == 2'b11) begin // Caso instução Formato II
	         if(instrucao[10] == 1'b0)
	           controleEX = 2'b01; // lcl c, Const8
	         if(instrucao[10] == 1'b1)
	           controleEX = 2'b10; // lch c, Const8 
	         EX_constante = instrucao[7:0];  
	      end else begin
	         prox_estado = 3'b000; // Estado Inicial
	         break;
	      end
	      
	      prox_estado = 3'b011; 
	    end
	    
	    3'b011: begin // A instrução é executada e as condições dos resultados são calculados *********************************
	      
	      if(instrucao[15:14] == 2'b10) // Operações Logicas Aritméticas
	         controleMUX_ULA = 1'b0;
	      else
	        controleMUX_ULA = 1'b1;
	      
	      /* Faltando a estrutura da ula completa e os codigos de ativação para as constantes 
	      if(instrucao[15:14] == 2'b10)
	        controleULA = instrucao[10:6];
	      else if(instrucao[15:14] == 2'b01)
	        controleULA = CódigoDeAtivaçao;
	      else if(instrucao[15:14] == 2'b11)
	        controleULA = CódigoDeAtivaçao;
	        */
	        
	      prox_estado = 3'b100; 
	    end

	    	    
	    3'b100: begin // Os resultados são escritos no banco de registradores
	      // BR_Entrada = ULA.RESU;
	      BR_Hab_Escrita = 1'b1; // Habilita escrita
	      prox_estado = 3'b000; 
	    end
	    
	    default: begin
	        prox_estado = 3'b001; // (volta ao primeiro ciclo)
	    end
		  
	  endcase
	end
	
endmodule