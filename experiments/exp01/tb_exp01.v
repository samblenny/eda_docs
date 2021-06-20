`timescale 1ns / 1fs
`define CLOCK_NS (1000.0 / 24.0)

module tb_exp01;
   // To create this instantiation with verilog-mode:
   // 1. Start with
   //    /*AUTOWIRE*/
   //    /*AUTOREGINPUT*/
   //    exp01 exp01(/*AUTOINST*/);
   // 2. Do: C-c C-a

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 green;                  // From blinky_ of blinky.v
   wire                 red;                    // From blinky_ of blinky.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  clk;                    // To blinky_ of blinky.v
   reg                  green_en;               // To blinky_ of blinky.v
   reg                  red_en;                 // To blinky_ of blinky.v
   reg                  reset;                  // To blinky_ of blinky.v
   // End of automatics
   blinky blinky_(/*AUTOINST*/
                  // Outputs
                  .red                  (red),
                  .green                (green),
                  // Inputs
                  .clk                  (clk),
                  .reset                (reset),
                  .red_en               (red_en),
                  .green_en             (green_en));

   initial green_en <= 1'b1;
   initial red_en <= 1'b0;

   initial begin
      reset <=1'b1;
      #(`CLOCK_NS * 1.0) reset <= 1'b0;
   end

   // The clock is phase shifted so that the second @(posedge clk) after end of
   // reset will happen at exactly 100ns in the gtkwave timeline. The point is
   // to have the LED level transitions aligned nicely so timer calibration is
   // more obvious.
   initial begin
      clk <= 1'b1;
      #(100.000001 - (`CLOCK_NS * 2.0));
      forever #(`CLOCK_NS / 2.0) clk <= ~clk;
   end

   initial begin
      $display("=== Starting Simulation ===");
      $dumpfile("build/tb_exp01.fst");
      $dumpvars(0,blinky_);
      // Run for ~1s to catch full cycle of blink PWM + many cycles of dim PWM
      #(1_000_001_000) begin
         $display("=== Done ===");
         $finish;
      end
   end

endmodule
