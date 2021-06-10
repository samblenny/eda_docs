// verilog-mode: https://veripool.org/verilog-mode/help/

module exp01(/*AUTOARG*/
   // Outputs
   out_1, out_2,
   // Inputs
   in_1, in_2, in_3
   );
   input in_1, in_2, in_3;
   output out_1, out_2;   
   /*AUTOINPUT*/
   /*AUTOOUTPUT*/
   /*AUTOWIRE*/
   /*AUTOREG*/
   assign out_1 = in_1 & in_2 & in_3;
   assign out_2 = in_1 | in_2 | in_3;
endmodule
