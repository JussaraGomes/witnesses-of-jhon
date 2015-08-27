module Clock(clk);
  output logic clk;
  initial #5 clk = 1; // Inicializa clock com um 
  always #50 clk = ~ clk; // Uma transicao de clock a cada 50 unidades de tempo
endmodule 
