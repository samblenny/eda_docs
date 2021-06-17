`include "pll.v"

module exp01(
   // Outputs
   output LED_GREEN, LED_RED,
   // Inputs
   input ICE_CLK, IOT_37A, IOT_36B
   );

   // Timing calculations are for 24_000_000 Hz clock
   // prescale: 240 * 42ns ticks --> overflow at 10us
   // s_timer: 100_000 * 10us ticks --> overflow at 1s
   // *_msb are sized to use as bitfield msb index
   // *_init and *_max constants are sized to include carry bit
   localparam prescale_ticks = 240;
   localparam s_timer_ticks = 100_000;
   localparam prescale_msb = $clog2(prescale_ticks);             // size of prescale reg; msb is carry
   localparam prescale_max = {1'b0, (2**prescale_msb)-1};        // max prescale value before overflow
   localparam prescale_init = prescale_max + 1 - prescale_ticks; // calibrated prescale overflow value
   localparam s_timer_msb = $clog2(s_timer_ticks);               // size of s_timer reg; msb is carry
   localparam s_timer_max = {1'b0, (2**s_timer_msb)-1};          // max s_timer value before overflow
   localparam s_timer_init = s_timer_max + 1 - s_timer_ticks;    // calibrated s_timer overflow value
   localparam s_timer_150ms = s_timer_max + 1 - 15000;           // 150.00ms before s_timer overflow

   reg [prescale_msb:0] prescale = 0;
   reg [s_timer_msb:0]  s_timer = 0;
   reg                  led_en = 0;
   reg                  led_pwm = 0;

   wire pll_locked, clk;
   pll pll_ (.clock_in(ICE_CLK), .clock_out(clk), .locked(pll_locked));
   wire reset = ~pll_locked;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         prescale <= prescale_init;
         s_timer <= s_timer_init;
         led_en <= 0;
         led_pwm <= 0;
         /*AUTORESET*/
      end
      else begin
         // Increment timers, checking carry bits to use calibrated overflow values
         prescale <= prescale[prescale_msb] ? prescale_init : prescale + 1;
         if (prescale[prescale_msb]) begin
            s_timer <= s_timer[s_timer_msb] ? s_timer_init : s_timer + 1;
         end
         // Update LED signals: en controls visible duty cycle, pwm controls dimming
         case (s_timer)
           s_timer_150ms: led_en <= 1;
           s_timer_max: led_en <= 0;
           default: ;
         endcase
         led_pwm <= &s_timer[6:0];
      end
   end

   // Pulse LED, active low
   assign LED_GREEN = ~(IOT_37A & led_en & led_pwm);
   assign LED_RED = ~(IOT_36B & led_en & led_pwm);

endmodule
