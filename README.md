# fpga-video
Generate video output with an FPGA.

This particular project uses a Sipeed Tang Nano 9k FPGA board with a 4.3 inch 480×272 LCD screen.  The particular screen I used is the following:

https://www.aliexpress.com/item/1005004392988205.html

https://www.lazada.com.ph/products/shockley-43-inch-33v-480x272-resolution-rgb-gc3047-ic-driver-350-bright-tft-lcd-display-module-without-touch-40pin-plug-in-24-bit-lcd-color-screen-i3536371310-s18225500152.html

The LEDs should pulse at 0.5 second each running off the pixel clock, which is set to 9 MHz as required by the screen itself.

The reset button will reset the screen, while the user button can be used to toggle between the SMPTE colour bar pattern and the grid test pattern from Chapter 10 of _Designing Video Game Hardware in Verilog_, by Steven Hugg.

It should not be too difficult to port this to use a different FPGA: the main issue will be the use of the necessary IP blocks to generate the 9 MHz pixel clock required by the screen.

The Makefile provided uses the OSS CAD Suite:

https://github.com/YosysHQ/oss-cad-suite-build

I have not tried the official Tang Nano IDE, though presumably it could also be used to build this project easily enough.

