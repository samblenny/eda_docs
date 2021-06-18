// dual_timer module design:
// 1. Prescaler divides clk by PRESCALE_TICKS
// 2. Prescaler overflow (carry bit) advances internal registers for timer 1 and timer 2
// 3. Outputs t1 and t2 are PWM square waves controlled by timer 1 and timer 2
// 4. Periods of t1 and t2 are T1_TICKS and T2_TICKS prescaler periods long
// 5. Duty cycles of t1 and t2 are T1_HOLD_TICKS/T1_TICKS and T2_HOLD_TICKS/T2_TICKS

module dual_timer(/*AUTOARG*/
   // Outputs
   t1, t2,
   // Inputs
   clk, reset
   );
   output reg t1, t2;
   input  clk, reset;

   // Timing calculations are for 24_000_000 Hz clock
   // - prescale: 600 * 41.667ns ticks --> overflow at 25us
   // - timer 1: 40_000 * 25us ticks --> overflow at 1s
   // - timer 1 hold: 6_000 * 25us ticks --> t1 output duty cycle: 150ms / 850ms
   // - timer 2: 333 * 25us ticks --> overflow at 8.33ms (~120 Hz)
   // - timer 2 hold: 1 * 25us ticks --> t2 output duty cycle: 0.025ms / 8.33ms
   // The width'(constant_expression) casts ensure uniform width of calculated constants
   parameter PRESCALE_TICKS = 600;
   parameter T1_TICKS = 40_000;
   parameter T1_HOLD_TICKS = 6_000;
   parameter T1_INIT_PHASE = 1;
   parameter T2_TICKS = 333;
   parameter T2_HOLD_TICKS = 1;
   parameter T2_INIT_PHASE = 1;

   localparam pre_msb = $clog2(PRESCALE_TICKS);                // high bound of prescale reg; msb is carry
   localparam pre_size = pre_msb+1;                            // prescale size incl. carry bit (for type casts)
   localparam pre_max = pre_size'((2**pre_msb)-1);             // max prescale value before overflow
   localparam pre_init = pre_size'(pre_max+1-PRESCALE_TICKS);  // calibrated prescale overflow value

   localparam t1_msb = $clog2(T1_TICKS);                       // high bound timer 1 reg; msb is carry
   localparam t1_size = t1_msb+1;                              // timer 1 size incl. carry bit (for casts)
   localparam t1_max = t1_size'((2**t1_msb)-1);                // max timer 1 value before overflow
   localparam t1_init = t1_size'(t1_max+1-T1_TICKS);           // calibrated timer 1 overflow value
   localparam t1_hold = t1_size'(t1_init+T1_HOLD_TICKS);       // timer1 phase marking end of t1 overflow pulse

   localparam t2_msb = $clog2(T2_TICKS);                       // high bound timer 2 reg; msb is carry
   localparam t2_size = t2_msb+1;                              // timer 2 size incl. carry bit (for casts)
   localparam t2_max = t2_size'((2**t2_msb)-1);                // max timer 2 value before overflow
   localparam t2_init = t2_size'(t2_max+1-T2_TICKS);           // calibrated timer 2 overflow value
   localparam t2_hold = t2_size'(t2_init+T2_HOLD_TICKS);       // timer2 phase marking end of t2 overflow pulse

   reg [pre_msb:0] prescale = pre_init;
   reg [t1_msb:0]  timer1 = t1_init;
   reg [t2_msb:0]  timer2 = t2_init;

   always @(posedge clk or posedge reset/*AS*/) begin
      if (reset) begin
         prescale <= pre_init;
         timer1 <= t1_init;
         timer2 <= t2_init;
         t1 <= T1_INIT_PHASE;
         t2 <= T2_INIT_PHASE;
         /*AUTORESET*/
      end
      else begin
         // Increment timers, checking carry bits to use calibrated overflow values
         prescale <= prescale[pre_msb] ? pre_init : prescale + 1;
         if (prescale[pre_msb]) begin
            timer1 <= timer1[t1_msb] ? t1_init : timer1 + 1;
            timer2 <= timer2[t2_msb] ? t2_init : timer2 + 1;
         end
         // Manage t1 PWM toggle
         case(timer1)
           t1_init: t1 <= T1_INIT_PHASE;
           t1_hold: t1 <= ~T1_INIT_PHASE;
           default: ;
         endcase;
         // Manage t2 PWM toggle
         case(timer2)
           t2_init: t2 <= T2_INIT_PHASE;
           t2_hold: t2 <= ~T2_INIT_PHASE;
           default: ;
         endcase;
      end
   end
endmodule
