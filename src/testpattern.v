/* Simple test pattern generator

   Generates the SMPTE Colour Bars, and the test pattern from Chapter 10 of
   _Designing Video Game Hardware in Verilog_, by Steven Hugg. */

`include "hvsync.v"
`include "rpll.v"

module testpattern(input 	clk,
		   input 	reset,
		   input 	userbtn, 
		   output [5:0] led,
		   output 	clkd,
		   output 	hsync,
		   output 	vsync,
		   output 	disp_en,
		   output [4:0] r,
		   output [5:0] g,
		   output [4:0] b);

   wire [16:0] 			x;
   wire [16:0] 			y;
   wire 			nf, nl;
   reg 				mode;
   reg [32:0] 			counter;

   Gowin_rPLL chip_pll(.clkoutd(clkd),
		       .clkin(clk));
   hvsync hvs(.pclk(clkd),
	      .reset(reset),
	      .hsync(hsync),
	      .vsync(vsync),
	      .disp_en(disp_en),
	      .hpos(x[16:0]),
	      .vpos(y[16:0]),
	      .newframe(nf),
	      .newline(nl));

   // Parameters for SMPTE colour bars. These values are correct for 480×272
   // displays.  Adjust accordingly if your display has different size.
   localparam BARWIDTH = 68; // Width of a colour bar (⅐ of the width)
   localparam BARHEIGHT = 181; // Height of a colour bar (⅔ of the height)
   localparam CAST_YMAX = 202; // Y-position of the end of the castellations, 8% of the total height
   localparam PLUGE_WIDTH = 96;	// Width of a PLUGE pulse (1/5 of the width)

   assign r = (disp_en) ?
	      ((!mode) ?
	       ((y < BARHEIGHT) ?
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
		 (x < PLUGE_WIDTH*2) ? 5'h1f : 5'h00)) :
	       ((x & 9'h7) == 0 || (y & 9'h7) == 0) ? 5'h1f : 5'h00) :
	      5'h00;
   
   assign g = (disp_en) ?
	      ((!mode) ?
	       ((y < BARHEIGHT) ?
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
		 (x < PLUGE_WIDTH*2) ? 6'h3f : 5'h00)) :
	       (y[4] ? 6'h3f : 6'h00)) :
	       6'h00;

   assign b = (disp_en) ?
	      ((!mode) ?
	       ((y < BARHEIGHT) ?
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
		 (x < PLUGE_WIDTH*2) ? 5'h1f : 5'h00)) :
	       (x[4] ? 5'h1f : 5'h00)) :
	      5'h00;;

   always @(negedge reset or negedge userbtn)
     begin
	if (!reset)
	  mode <= 0;
	else if (!userbtn)
	  mode <= !mode;
     end

   always @(posedge clkd or negedge reset)
     begin
	if (!reset)
	  begin
	     counter <= 0;
	  end
	else if (counter < 31'd4_499_999)
	  begin
	     counter <= counter + 1;
	  end
	else
	  begin
	     counter <= 0;
	  end
     end

   always @(posedge clkd or negedge reset)
     begin
	if (!reset)
	  led <= 6'b111110;
	else if (counter >= 31'd4_499_999)
	  led[5:0] <= {led[4:0], led[5]};
	else
	  led <= led;
     end

endmodule // testpattern
