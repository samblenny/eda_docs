// blinky: Modulate LEDs with enable switch * blinking PWM * dimming PWM
module blinky(/*AUTOARG*/
   // Outputs
   red, green,
   // Inputs
   clk, reset, red_en, green_en
   );
   output red, green;
   input  clk, reset, red_en, green_en;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 t1;                     // From dt of dual_timer.v
   wire                 t2;                     // From dt of dual_timer.v
   // End of automatics
   /*AUTOREGINPUT*/

   // See dual_timer.v for t1 & t2 PWM default period and duty cycle parameters
   dual_timer dt (/*AUTOINST*/
                  // Outputs
                  .t1                   (t1),
                  .t2                   (t2),
                  // Inputs
                  .clk                  (clk),
                  .reset                (reset));

   // Assume LED outputs are active low; t1 is blink PWM; t2 is dim PWM
   assign red = ~(red_en & t1 & t2);
   assign green = ~(green_en & t1 & t2);

endmodule
