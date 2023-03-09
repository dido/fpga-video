/* RPLL clock generator module.
 The values for the PLL to make various frequencies I got from here:

 https://juj.github.io/gowin_fpga_code_generators/pll_calculator.html
 
 Apparently the formulas are as follows:
 
 FCLKIN is the input clock frequency. It is 27 MHz for the Tang Nano 9k
 The parameters are IDIV_SEL, FBDIV_SEL, and ODIV_SEL.
 
 PFD = FCLKIN / (IDIV_SEL + 1)
 CLKOUT = FCLKIN * (FBDIV_SEL + 1) / (IDIV_SEL + 1)
 VCO = (FCLKIN * (FBDIV_SEL+1) * ODIV_SEL) / (IDIV_SEL+1)
 CLKOUTD = CLKOUT / DYN_SDIV_SEL
 */
module Gowin_rPLL (clkout, clkoutd, clkin);
   output clkout;
   output clkoutd;
   input  clkin;

   wire   lock_o;
   wire   clkoutp_o;
   wire   clkoutd3_o;
   wire   gw_gnd;

   assign gw_gnd = 1'b0;

   rPLL rpll_inst (.CLKOUT(clkout),
		   .LOCK(lock_o),
		   .CLKOUTP(clkoutp_o),
		   .CLKOUTD(clkoutd),
		   .CLKOUTD3(clkoutd3_o),
		   .RESET(gw_gnd),
		   .RESET_P(gw_gnd),
		   .CLKIN(clkin),
		   .CLKFB(gw_gnd),
		   .FBDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
		   .IDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
		   .ODSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
		   .PSDA({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
		   .DUTYDA({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
		   .FDLY({gw_gnd,gw_gnd,gw_gnd,gw_gnd}));

   /* These parameters get us a 9 MHz clock with the 27 MHz crystal 
      on the Sipeed Tang Nano 9k */
   defparam rpll_inst.IDIV_SEL = 2;
   defparam rpll_inst.FBDIV_SEL = 3;
   defparam rpll_inst.ODIV_SEL = 32;
   defparam rpll_inst.DYN_SDIV_SEL = 4;

   defparam rpll_inst.FCLKIN = "27";
   defparam rpll_inst.DYN_IDIV_SEL = "false";
   defparam rpll_inst.DYN_FBDIV_SEL = "false";
   defparam rpll_inst.DYN_ODIV_SEL = "false";
   defparam rpll_inst.PSDA_SEL = "0000";
   defparam rpll_inst.DYN_DA_EN = "false";
   defparam rpll_inst.DUTYDA_SEL = "1000";
   defparam rpll_inst.CLKOUT_FT_DIR = 1'b1;
   defparam rpll_inst.CLKOUTP_FT_DIR = 1'b1;
   defparam rpll_inst.CLKOUT_DLY_STEP = 0;
   defparam rpll_inst.CLKOUTP_DLY_STEP = 0;
   defparam rpll_inst.CLKFB_SEL = "internal";
   defparam rpll_inst.CLKOUT_BYPASS = "false";
   defparam rpll_inst.CLKOUTP_BYPASS = "false";
   defparam rpll_inst.CLKOUTD_BYPASS = "false";
   defparam rpll_inst.CLKOUTD_SRC = "CLKOUT";
   defparam rpll_inst.CLKOUTD3_SRC = "CLKOUT";
   defparam rpll_inst.DEVICE = "GW1NR-9C";
endmodule //Gowin_rPLL
