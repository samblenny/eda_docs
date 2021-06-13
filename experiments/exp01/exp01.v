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
   reg [25:0] count = 0;
   wire pll_clk_out, pll_locked, clk, reset;
   /*AUTOINPUT*/
   /*AUTOOUTPUT*/
   /*AUTOWIRE*/
   /*AUTOREG*/

   pll pll_ (.clock_in(ICE_CLK), .clock_out(clk), .locked(pll_locked));
   assign reset = ~pll_locked;

   always @(posedge clk or posedge reset /*AS*/) begin
      if (reset) begin
         count <= 0;
         LED_RED <= 0;
      end
      else begin
         case (count)
           0: count <= 26'd9554433;      // Trim offset to get 1Hz MSB toggle: (2^25)-24e6+1
           default: count <= count + 1;
         endcase
         LED_RED <= count[25];
      end
   end

endmodule
