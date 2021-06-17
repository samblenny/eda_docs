`include "pll.v"

module exp01(
   output LED_GREEN, LED_RED,
   input ICE_CLK, IOT_37A, IOT_36B
   );

   // Timing calculations are for 24_000_000 Hz clock
   // prescale: 240 * 42ns ticks --> overflow at 10us
   // s_timer: 100_000 * 10us ticks --> overflow at 1s
   // The width'(constant_expression) casts ensure uniform width of calculated constants
   parameter prescale_ticks = 240;
   parameter s_timer_ticks = 100_000;
   localparam pre_msb = $clog2(prescale_ticks);                // high bound of prescale reg; msb is carry
   localparam pre_size = pre_msb+1;                            // prescale size incl. carry bit (for type casts)
   localparam pre_max = pre_size'((2**pre_msb)-1);             // max prescale value before overflow
   localparam pre_init = pre_size'(pre_max+1-prescale_ticks);  // calibrated prescale overflow value
   localparam st_msb = $clog2(s_timer_ticks);                  // high bound s_timer reg; msb is carry
   localparam st_size = st_msb+1;                              // s_timer size incl. carry bit (for type casts)
   localparam st_max = st_size'((2**st_msb)-1);                // max s_timer value before overflow
   localparam st_init = st_size'(st_max+1-s_timer_ticks);      // calibrated s_timer overflow value
   localparam st_150ms = st_size'(st_max+1-15000);             // 150.00ms before s_timer overflow

   reg [pre_msb:0] prescale = 0;
   reg [st_msb:0]  s_timer = 0;
   reg             led_en = 0;
   reg             led_pwm = 0;

   wire pll_locked, clk;
   pll pll_ (.clock_in(ICE_CLK), .clock_out(clk), .locked(pll_locked));
   wire reset = ~pll_locked;

   always @(posedge clk or posedge reset/*AS*/) begin
      if (reset) begin
         prescale <= pre_init;
         s_timer <= st_init;
         led_en <= 0;
         led_pwm <= 0;
         /*AUTORESET*/
      end
      else begin
         // Increment timers, checking carry bits to use calibrated overflow values
         prescale <= prescale[pre_msb] ? pre_init : prescale + 1;
         if (prescale[pre_msb]) begin
            s_timer <= s_timer[st_msb] ? st_init : s_timer + 1;
         end
         // Update LED signals: led_en controls visible duty cycle, led_pwm controls dimming
         case (s_timer)
           st_150ms: led_en <= 1;
           st_max: led_en <= 0;
           default: ;
         endcase
         led_pwm <= &s_timer[6:0];
      end
   end

   // Pulse LED, active low
   assign LED_GREEN = ~(IOT_37A & led_en & led_pwm);
   assign LED_RED = ~(IOT_36B & led_en & led_pwm);

endmodule
