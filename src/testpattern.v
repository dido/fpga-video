/* Simple test pattern generator

   Generates the SMPTE Colour Bars, and the test pattern from Chapter 10 of
   _Designing Video Game Hardware in Verilog_, by Steven Hugg. */

`include "hvsync.v"
`include "rpll.v"
`include "hexdigits.v"
`include "smpte.v"

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
   // Mode register bits:
   // 00 - SMPTE colour bars
   // 01 - Grid test pattern
   // 10 - Bitmap digits test
   // 11 - Black screen (presently unused)
   reg [1:0] 			mode;

   // Counter bits used to drive the LEDs
   reg [32:0] 			counter;

   // X and Y position of current scan line as generated by H/V sync gen
   wire [16:0] 			x;
   wire [16:0] 			y;

   // RGB values eventually set to output RGB
   wire [4:0] 			rr;
   wire [5:0] 			gg;
   wire [4:0] 			bb;

   // New frame / New scan line signals (not yet used)
   wire 			nf, nl;

   // RGB values generated by SMPTE generator
   wire [4:0] 			rs;
   wire [5:0] 			gs;
   wire [4:0] 			bs;

   // Digit selectors for bitmap digits
   wire [3:0] 			digit = x[7:4];
   wire [2:0] 			xofs = x[3:1];
   wire [2:0] 			yofs = y[3:1];
   wire [4:0] 			bits;

   // RPLL for pixel clock generator
   Gowin_rPLL chip_pll(.clkoutd(clkd),
		       .clkin(clk));

   // Horizontal / Vertical Sync Generator
   hvsync hvs(.pclk(clkd),
	      .reset(reset),
	      .hsync(hsync),
	      .vsync(vsync),
	      .disp_en(disp_en),
	      .hpos(x[16:0]),
	      .vpos(y[16:0]),
	      .newframe(nf),
	      .newline(nl));

   // SMPTE Colour Bar generator
   smpte colorbars(.x(x[16:0]),
		   .y(y[16:0]),
		   .r(rs[4:0]),
		   .g(gs[5:0]),
		   .b(bs[4:0]));

   // Bitmap digit ROM
   hexdigits numbers(.digit(digit),
		     .yofs(yofs),
		     .bits(bits));

   always @(*)
     case (disp_en)
       1'b0:
	 begin
	    rr <= 5'b0;
	    gg <= 6'b0;
	    bb <= 5'b0;
	 end
       1'b1:
	 begin
	    case (mode)
	      2'b00:
		begin
		   // RGB values from SMPTE pattern generator
		   rr <= rs;
		   gg <= gs;
		   bb <= bs;
		end
	      2'b01:
		begin
		   // Test pattern from DVGHV Ch. 10
		   rr <= ((x & 9'h7) == 0 || (y & 9'h7) == 0) ? 5'h1f : 5'h00;
       		   gg <= (y[4]) ? 6'h3f : 6'h00;
		   bb <= (x[4]) ? 5'h1f : 5'h00;
		end
	      2'b10:
		begin
		   // Bitmap ROM characters
		   rr <= 5'h00;
		   gg <= ((((xofs ^ 3'b111) < 5) && (yofs < 5)) ? bits[xofs ^ 3'b111] : 0) ? 6'h3f : 6'h00;
		   bb <= 5'h00;
		end
	      2'b11:
		begin
		   // For future use
		   rr <= 5'h00;
		   gg <= 6'h00;
		   bb <= 5'h00;
		end
	    endcase // case (mode)
	 end
     endcase // case (disp_en)

   assign r = rr;
   assign g = gg;
   assign b = bb;

   always @(negedge reset or negedge userbtn)
     begin
	if (!reset)
	  mode <= 2'b00;
	else if (!userbtn)
	  mode <= mode + 1;
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
