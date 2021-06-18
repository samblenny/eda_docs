// Wrapper wiring blinky.v to iCE40 PLL and IO hardware blocks of UP5K breakout board

module exp01(/*AUTOARG*/
   // Outputs
   LED_GREEN, LED_RED,
   // Inputs
   ICE_CLK, IOT_37A, IOT_36B
   );
   output LED_GREEN, LED_RED;
   input  ICE_CLK, IOT_37A, IOT_36B;

   // Connect iCE40 IO pins for UP5K breakout board LEDs and switches
   wire             green = LED_GREEN;
   wire             red = LED_RED;
   wire             green_en = IOT_37A;
   wire             red_en = IOT_36B;

   // Connect iCE40 PLL hardware block to oscillator, reset, and clock buffer
   wire                 clk = clock_out;
   wire                 reset = ~locked;
   wire                 clock_in = ICE_CLK;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 clock_out;              // From pll_ of pll.v
   wire                 locked;                 // From pll_ of pll.v
   // End of automatics
   /*AUTOREGINPUT*/

   // Instantiate iCE40 hardware PLL block
   pll pll_ (/*AUTOINST*/
             // Outputs
             .clock_out         (clock_out),
             .locked            (locked),
             // Inputs
             .clock_in          (clock_in));

   // Instantiate the wrapped module that does not depend on hardware blocks
   blinky blinky_(/*AUTOINST*/
                  // Outputs
                  .red                  (red),
                  .green                (green),
                  // Inputs
                  .clk                  (clk),
                  .reset                (reset),
                  .red_en               (red_en),
                  .green_en             (green_en));

endmodule
