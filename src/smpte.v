/* SMPTE colour bar generator module */
module smpte(input [16:0] x,
	     input [16:0] y,
	     output [4:0] r,
	     output [5:0] g,
	     output [4:0] b);

   // Parameters for SMPTE colour bars. These values are correct for 480×272
   // displays.  Adjust accordingly if your display has different size.
   localparam BARWIDTH = 68; // Width of a colour bar (⅐ of the width)
   localparam BARHEIGHT = 181; // Height of a colour bar (⅔ of the height)
   localparam CAST_YMAX = 202; // Y-position of the end of the castellations, 8% of the total height
   localparam PLUGE_WIDTH = 96;	// Width of a PLUGE pulse (1/5 of the width)

   always @(*)
     begin
	r <= ((y < BARHEIGHT) ?
	      ((x < BARWIDTH) ? 5'h16 :
    	       (x < BARWIDTH*2) ? 5'h16 :
    	       (x < BARWIDTH*3) ? 5'h02 :
	       (x < BARWIDTH*4) ? 5'h02 :
	       (x < BARWIDTH*5) ? 5'h16 :
	       (x < BARWIDTH*6) ? 5'h16 : 5'h02) :
	      ((y < CAST_YMAX) ?
	       ((x < BARWIDTH) ? 5'h02 :
    		(x < BARWIDTH*2) ? 5'h02 :
    		(x < BARWIDTH*3) ? 5'h16 :
		(x < BARWIDTH*4) ? 5'h02 :
		(x < BARWIDTH*5) ? 5'h02 :
		(x < BARWIDTH*6) ? 5'h02 : 5'h16) :
	       (x < PLUGE_WIDTH) ? 5'h00 :
	       (x < PLUGE_WIDTH*2) ? 5'h1f : 5'h00));
	g <= (y < BARHEIGHT) ?
	     ((x < BARWIDTH) ? 6'h2d :
    	      (x < BARWIDTH*2) ? 6'h2d :
    	      (x < BARWIDTH*3) ? 6'h2d :
	      (x < BARWIDTH*4) ? 6'h2d :
	      (x < BARWIDTH*5) ? 6'h04 :
	      (x < BARWIDTH*6) ? 6'h04 : 6'h04) :
	     ((y < CAST_YMAX) ?
	      ((x < BARWIDTH) ? 6'h04 :
    	       (x < BARWIDTH*2) ? 6'h04 :
    	       (x < BARWIDTH*3) ? 6'h04 :
	       (x < BARWIDTH*4) ? 6'h04 :
	       (x < BARWIDTH*5) ? 6'h2d :
	       (x < BARWIDTH*6) ? 6'h04 : 6'h2d) :
	      (x < PLUGE_WIDTH) ? 6'h00 :
	      (x < PLUGE_WIDTH*2) ? 6'h3f : 5'h00);
	b <= (y < BARHEIGHT) ?
	     ((x < BARWIDTH) ? 5'h16 :
    	      (x < BARWIDTH*2) ? 5'h02 :
    	      (x < BARWIDTH*3) ? 5'h16 :
	      (x < BARWIDTH*4) ? 5'h02 :
	      (x < BARWIDTH*5) ? 5'h16 :
	      (x < BARWIDTH*6) ? 5'h02 : 5'h16) :
	     ((y < CAST_YMAX) ?
	      ((x < BARWIDTH) ? 5'h16 :
    	       (x < BARWIDTH*2) ? 5'h02 :
    	       (x < BARWIDTH*3) ? 5'h16 :
	       (x < BARWIDTH*4) ? 5'h02 :
	       (x < BARWIDTH*5) ? 5'h16 :
	       (x < BARWIDTH*6) ? 5'h02 : 5'h16) :
	      (x < PLUGE_WIDTH) ? 5'h00 :
	      (x < PLUGE_WIDTH*2) ? 5'h1f : 5'h00);
     end
endmodule // smpte
