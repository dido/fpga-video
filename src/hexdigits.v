/* ROM module with 5x5 bitmaps for digits 0-9 and letters A thru F.
   Adapted from _Designing Video Game Hardware in Verilog_, by Steven Hugg.
   Original code extracted from:
 
   https://github.com/sehugg/fpga-examples
 
   licensed under CC0
 */

module hexdigits(digit, yofs, bits);
  
  input [3:0] digit;		// digit 0-9
  input [2:0] yofs;		// vertical offset (0-4)
  output [4:0] bits;		// output (5 bits)

  reg [4:0] bitarray[16][5];	// ROM array (16 x 5 x 5 bits)

  assign bits = bitarray[digit][yofs];	// assign module output
  
  integer i,j;
  
  initial begin/*{w:5,h:5,count:10}*/
     bitarray[0][0] = 5'b11111;
     bitarray[0][1] = 5'b11001;
     bitarray[0][2] = 5'b10101;
     bitarray[0][3] = 5'b10011;
     bitarray[0][4] = 5'b11111;

     bitarray[1][0] = 5'b01100;
     bitarray[1][1] = 5'b00100;
     bitarray[1][2] = 5'b00100;
     bitarray[1][3] = 5'b00100;
     bitarray[1][4] = 5'b11111;

     bitarray[2][0] = 5'b11111;
     bitarray[2][1] = 5'b00001;
     bitarray[2][2] = 5'b11111;
     bitarray[2][3] = 5'b10000;
     bitarray[2][4] = 5'b11111;

     bitarray[3][0] = 5'b11111;
     bitarray[3][1] = 5'b00001;
     bitarray[3][2] = 5'b11111;
     bitarray[3][3] = 5'b00001;
     bitarray[3][4] = 5'b11111;

     bitarray[4][0] = 5'b10001;
     bitarray[4][1] = 5'b10001;
     bitarray[4][2] = 5'b11111;
     bitarray[4][3] = 5'b00001;
     bitarray[4][4] = 5'b00001;

     bitarray[5][0] = 5'b11111;
     bitarray[5][1] = 5'b10000;
     bitarray[5][2] = 5'b11111;
     bitarray[5][3] = 5'b00001;
     bitarray[5][4] = 5'b11111;

     bitarray[6][0] = 5'b11111;
     bitarray[6][1] = 5'b10000;
     bitarray[6][2] = 5'b11111;
     bitarray[6][3] = 5'b10001;
     bitarray[6][4] = 5'b11111;

     bitarray[7][0] = 5'b11111;
     bitarray[7][1] = 5'b00001;
     bitarray[7][2] = 5'b00001;
     bitarray[7][3] = 5'b00001;
     bitarray[7][4] = 5'b00001;

     bitarray[8][0] = 5'b11111;
     bitarray[8][1] = 5'b10001;
     bitarray[8][2] = 5'b11111;
     bitarray[8][3] = 5'b10001;
     bitarray[8][4] = 5'b11111;

     bitarray[9][0] = 5'b11111;
     bitarray[9][1] = 5'b10001;
     bitarray[9][2] = 5'b11111;
     bitarray[9][3] = 5'b00001;
     bitarray[9][4] = 5'b11111;
     
     bitarray[10][0] = 5'b01110;
     bitarray[10][1] = 5'b10001;
     bitarray[10][2] = 5'b11111;
     bitarray[10][3] = 5'b10001;
     bitarray[10][4] = 5'b10001;

     bitarray[11][0] = 5'b11110;
     bitarray[11][1] = 5'b10001;
     bitarray[11][2] = 5'b11110;
     bitarray[11][3] = 5'b10001;
     bitarray[11][4] = 5'b11110;

     bitarray[12][0] = 5'b11111;
     bitarray[12][1] = 5'b10000;
     bitarray[12][2] = 5'b10000;
     bitarray[12][3] = 5'b10000;
     bitarray[12][4] = 5'b11111;

     bitarray[13][0] = 5'b11110;
     bitarray[13][1] = 5'b10001;
     bitarray[13][2] = 5'b10001;
     bitarray[13][3] = 5'b10001;
     bitarray[13][4] = 5'b11110; 

     bitarray[14][0] = 5'b11111;
     bitarray[14][1] = 5'b10000;
     bitarray[14][2] = 5'b11111;
     bitarray[14][3] = 5'b10000;
     bitarray[14][4] = 5'b11111;

     bitarray[15][0] = 5'b11111;
     bitarray[15][1] = 5'b10000;
     bitarray[15][2] = 5'b11111;
     bitarray[15][3] = 5'b10000;
     bitarray[15][4] = 5'b10000;
  end
endmodule
