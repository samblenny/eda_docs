// verilog-mode: https://veripool.org/verilog-mode/help/
`include "pll.v"

module exp01(/*AUTOARG*/
   // Outputs
   LED_RED,
   // Inputs
   ICE_CLK
   );
   input ICE_CLK;
   output reg LED_RED;
   reg [15:0] count = 0;
   wire pll_clk_out, pll_locked, clk;
   /*AUTOINPUT*/
   /*AUTOOUTPUT*/
   /*AUTOWIRE*/
   /*AUTOREG*/

   pll pll_ (.clock_in(ICE_CLK), .clock_out(pll_clk_out), .locked(pll_locked));
   SB_GB clk_gb (.USER_SIGNAL_TO_GLOBAL_BUFFER(pll_clk_out), .GLOBAL_BUFFER_OUTPUT(clk));

   always @(posedge clk /*AS*/) begin
      count <= count + 1;
      LED_RED <= count[15];
   end

endmodule
