// verilog-mode: https://veripool.org/verilog-mode/help/
`include "pll.v"

module exp01(/*AUTOARG*/
   // Outputs
   LED_GREEN,
   // Inputs
   ICE_CLK
   );

   output reg LED_GREEN;
   input ICE_CLK;
   /*AUTOOUTPUT*/
   /*AUTOINPUT*/

   // Timing calculations are for 24_000_000 Hz clock
   // prescale: 240 * 42ns ticks --> overflow at 10us
   // s_timer: 100_000 * 10us ticks --> overflow at 1s
   // *_msb are sized to use as bitfield msb index
   // *_init and *_max constants are sized to include carry bit
   localparam prescale_msb = 8;            // ceil(log2(240)); msb is carry
   localparam prescale_max = 9'd255;       // (2^8)-1; max value before overflow
   localparam prescale_init = 9'd16;       // (2^8)-240; max - ticks
   localparam s_timer_msb = 17;            // ceil(log2(100_000)); msb is carry
   localparam s_timer_max = 18'd131071;    // (2^17)-1; max value before overflow
   localparam s_timer_init = 18'd31072;    // (2^17)-(10^5); max - ticks
   localparam s_timer_150ms = 18'd116072;  // (2^17)-15000; 150ms before overflow

   reg [prescale_msb:0] prescale = 0;
   reg [s_timer_msb:0]  s_timer = 0;
   reg                  led_en = 0;
   reg                  led_pwm = 0;
   /*AUTOREG*/

   wire pll_clk_out, pll_locked, clk, reset;
   /*AUTOWIRE*/

   pll pll_ (.clock_in(ICE_CLK), .clock_out(clk), .locked(pll_locked));
   assign reset = ~pll_locked;

   always @(posedge clk or posedge reset /*AS*/) begin
      if (reset) begin
         prescale <= prescale_init;
         s_timer <= s_timer_init;
         led_en <= 0;
         led_pwm <= 0;
         LED_GREEN <= 1;  // LED active low
      end
      else begin
         // Increment timers, checking carry bits to use calibrated overflow values
         prescale <= prescale[prescale_msb] ? prescale_init : prescale + 1;
         if (prescale[prescale_msb]) begin
            s_timer <= s_timer[s_timer_msb] ? s_timer_init : s_timer + 1;
         end
         // Pulse LED: active low, enable controls visible duty cycle, pwm controls dimming
         case (s_timer)
           s_timer_150ms: led_en <= 1;
           s_timer_max: led_en <= 0;
           default: ;
         endcase
         led_pwm <= &s_timer[6:0];
         LED_GREEN = ~(led_en & led_pwm);
      end
   end

endmodule
