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

   localparam clk_hz = 24000000;     // 24 MHz clock
   localparam prescale_max = 239;    // tick=42ps; overflow at 10ns
   localparam prescale_msb = 7;      // ceil(log2(prescale_max))-1
   localparam s_timer_max = 99999;   // tick=10ns; overflow at 1s
   localparam s_timer_msb = 16;      // ceil(log2(ms_timer_max))-1

   wire pll_clk_out, pll_locked, clk, reset;
   /*AUTOWIRE*/

   reg [prescale_msb:0] prescale = 0;
   reg                  prescale_overflow = 0;
   reg [s_timer_msb:0]  s_timer = 0;
   reg                  led_en = 0;
   reg                  led_pwm = 0;
   /*AUTOREG*/

   pll pll_ (.clock_in(ICE_CLK), .clock_out(clk), .locked(pll_locked));
   assign reset = ~pll_locked;

   always @(posedge clk or posedge reset /*AS*/) begin
      if (reset) begin
         prescale <= 0;
         prescale_overflow <= 0;
         s_timer <= 0;
         led_en <= 0;
         led_pwm <= 0;
         LED_GREEN <= 1;   // LED active low
      end
      else begin
         // Prescaler overflows after 10ns
         if (prescale == prescale_max) begin
            prescale <= 0;
            prescale_overflow <= 1;
         end
         else begin
            prescale <= prescale + 1;
            prescale_overflow <= 0;
         end
         // s_timer overflows at 1 second
         if (prescale_overflow) begin
            s_timer <= (s_timer == s_timer_max) ? 0 : s_timer + 1;
         end
         // Pulse LED at 1Hz with 15% duty cycle (before dimming); LED is active low
         case (s_timer)
           0: led_en <= 1;
           15000: led_en <= 0;
           default: ;
         endcase
         led_pwm <= s_timer[6:0] == 0;
         LED_GREEN = ~(led_en & led_pwm);
      end
   end

endmodule
