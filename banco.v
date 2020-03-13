// Mux 8 para 1
module multiplexador (leitura1, leitura2, leitura3, leitura4, leitura5, leitura6, leitura7, leitura8, controle, data);

	input [15:0] leitura1, leitura2, leitura3, leitura4, leitura5, leitura6, leitura7, leitura8;
	input [2:0] controle;
	output reg [15:0] data;

	always @(controle, leitura1, leitura2, leitura3, leitura4, leitura5, leitura6, leitura7, leitura8)
	begin
		case (controle)
		3'd0: data <= leitura1;
		3'd1: data <= leitura2;
		3'd2: data <= leitura3;
		3'd3: data <= leitura4;
		3'd4: data <= leitura5;
		3'd5: data <= leitura6;
		3'd6: data <= leitura7;
		3'd7: data <= leitura8;
		endcase
	end
endmodule


// Registrador (Flip-Flop D)
module registrador(dado, clock, habilita, saida);

input [15:0] dado;
input clock, habilita;
output reg [15:0] saida;
  
always @( posedge clock)  
  if (habilita)
    saida <= dado;
endmodule


// Demux 3 para 8
module decodificador(entrada, saida);
	input [2:0] entrada;
	output reg [7:0] saida;
  
	always @(entrada)
	begin
		case (entrada)
		3'd0: saida <= 8'd1;
		3'd1: saida <= 8'd2;
		3'd2: saida <= 8'd4;
		3'd3: saida <= 8'd8;
		3'd4: saida <= 8'd16;
		3'd5: saida <= 8'd32;
		3'd6: saida <= 8'd64;
		3'd7: saida <= 8'd128;
		endcase
	end
endmodule


// Banco de registradores (Módulo principal)
module banco (input [2:0] Read1Add, Read2Add, WriteAdd,  
	input [15:0] entrada, input RW, clock, output [15:0] dado1, dado2);
	wire [7:0] saida_dec;
	wire [15:0] saida_reg0, saida_reg1, saida_reg2, saida_reg3, saida_reg4, saida_reg5, saida_reg6, saida_reg7;

	// registrador(input [15:0] dado, input clock, en, output reg [15:0] saida);
	registrador reg0(  entrada  , clock, saida_dec[0] & RW , saida_reg0);
	registrador reg1(  entrada  , clock, saida_dec[1] & RW , saida_reg1);
	registrador reg2(  entrada  , clock, saida_dec[2] & RW , saida_reg2);
	registrador reg3(  entrada  , clock, saida_dec[3] & RW , saida_reg3);
	registrador reg4(  entrada  , clock, saida_dec[4] & RW , saida_reg4);
	registrador reg5(  entrada  , clock, saida_dec[5] & RW , saida_reg5);
	registrador reg6(  entrada  , clock, saida_dec[6] & RW , saida_reg6);
	registrador reg7(  entrada  , clock, saida_dec[7] & RW , saida_reg7);

	// decodificador(input [2:0] entrada, output reg [7:0] saida);
	decodificador dec1( WriteAdd, saida_dec);

	//multiplexador (input [15:0] entrada1, entrada2, entrada3, entrada4, 
	//entrada5, entrada6, entrada7, entrada8, input [2:0] controle, output reg [15:0] data);
	multiplexador mux1(saida_reg0, saida_reg1, saida_reg2, saida_reg3, saida_reg4, saida_reg5, saida_reg6, saida_reg7, Read1Add, dado1);
	multiplexador mux2(saida_reg0, saida_reg1, saida_reg2, saida_reg3, saida_reg4, saida_reg5, saida_reg6, saida_reg7, Read2Add, dado2);
endmodule

