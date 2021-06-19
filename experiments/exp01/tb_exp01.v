`timescale 1ns / 1ps

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

   always #(42 / 2.0) clk <= ~clk;

   initial begin
      $display("=== Starting Simulation ===");
      $dumpfile("build/tb_exp01.vcd");
      $dumpvars(0,blinky_);
      green_en <= 1'b1;
      red_en <= 1'b0;
      clk <= 1'b0;
      reset <= 1'b1;
      #(42 * 1) reset <= 1'b0;
      #(200_000_002) begin
         $display("=== Done ===");
         $finish;
      end
   end

endmodule
