/* Horizontal / Vertical Sync Generator. The local parameters defined are for
   a 480×272 LCD screen.  This should probably work for VGA if you adjust
   the parameters accordingly and invert logic for hsync and vsync signals. */
`ifndef HVSYNC_H
 `define HVSYNC_H

module hvsync(input 	       pclk,
	      input 	       reset,
	      output 	       hsync,
	      output 	       vsync,
	      output 	       disp_en,
	      output reg [16:0] hpos,
	      output reg [16:0] vpos,
	      output reg       newframe,
	      output reg       newline
	      );

   localparam H_DISPLAY = 480;	// horizontal display width
   localparam H_BACK = 32;	// left border (back porch)
   localparam H_FRONT = 20;	// right border (front porch)
   localparam H_SYNC = 12;	// horizontal sync width

   localparam V_DISPLAY = 272;	// vertical display height
   localparam V_TOP = 32;	// vertical top border
   localparam V_BOTTOM = 5;	// vertical bottom border
   localparam V_SYNC = 5;	// vertical sync # lines

   localparam H_SYNC_START = H_DISPLAY + H_FRONT;
   localparam H_SYNC_END = H_DISPLAY + H_FRONT + H_SYNC - 1;
   localparam H_MAX = H_DISPLAY + H_BACK + H_FRONT + H_SYNC - 1;

   localparam V_SYNC_START = V_DISPLAY + V_BOTTOM;
   localparam V_SYNC_END = V_DISPLAY + V_BOTTOM + V_SYNC - 1;
   localparam V_MAX = V_DISPLAY + V_TOP + V_BOTTOM + V_SYNC - 1;

   assign hsync = ((hpos >= H_SYNC_START) && (hpos <= H_SYNC_END));
   assign vsync = ((vpos >= V_SYNC_START) && (vpos <= V_SYNC_END));
   assign disp_en = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);

   always @(posedge pclk or negedge reset)
     begin
	newframe <= 0;
	newline <= 0;		    
	if (!reset) begin
	   hpos <= 0;
	   vpos <= 0;
	   newframe <= 1;
	   newline <= 1;
	end else if (hpos < H_MAX) begin
	   hpos <= hpos + 1;
	end else begin
	   hpos <= 0;
	   newline <= 1;
	   if (vpos < V_MAX) begin
	      vpos <= vpos + 1;
	   end else begin
	      vpos <= 0;
	      newframe <= 1;
	   end
	end
     end

endmodule // hvsync

`endif //  `ifndef HVSYNC_H
