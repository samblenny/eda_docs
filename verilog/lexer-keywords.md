# Yosys Verilog Lexer Tokens

This page attempts to document lexer tokens recognized by the Yosys Verilog
frontend. The point is to understand which parts of Verilog and SystemVerilog
Yosys supports.

Yosys source:
```
$ git remote get-url origin
https://github.com/YosysHQ/yosys.git
$ git rev-parse HEAD
092f0cb01e91b65d5ecc7c8e45f0eefa30b8c205
```

Procedure for getting lexemes out of `yosys/frontends/verilog/verilog_lexer.l`
```
python3 gather_tokens.py $PATH_TO_YOSYS/frontends/verilog/verilog_lexer.l
```

## Verilog Frontend Lexemes

This table started off as the output of [gather_tokens.py](gather_tokens.py).

| Lexeme                          | Description |
|---------------------------------|-------------|
| `%=`                            |  |
| `&=`                            |  |
| `*=`                            |  |
| `++`                            |  |
| `+:`                            |  |
| `+=`                            |  |
| `--`                            |  |
| `-:`                            |  |
| `-=`                            |  |
| `.*`                            |  |
| `/=`                            |  |
| `::`                            |  |
| `<<<=`                          |  |
| `<<=`                           |  |
| `>>=`                           |  |
| `>>>=`                          |  |
| `^=`                            |  |
| `|=`                            |  |
| `always`                        |  |
| `always_comb`                   |  |
| `always_ff`                     |  |
| `always_latch`                  |  |
| `assert`                        |  |
| `assign`                        |  |
| `assume`                        |  |
| `automatic`                     |  |
| `begin`                         |  |
| `bit`                           |  |
| `byte`                          |  |
| `case`                          |  |
| `casex`                         |  |
| `casez`                         |  |
| `checker`                       |  |
| `const`                         |  |
| `cover`                         |  |
| `default`                       |  |
| `defparam`                      |  |
| `else`                          |  |
| `end`                           |  |
| `endcase`                       |  |
| `endchecker`                    |  |
| `endfunction`                   |  |
| `endgenerate`                   |  |
| `endinterface`                  |  |
| `endmodule`                     |  |
| `endpackage`                    |  |
| `endspecify`                    |  |
| `endtask`                       |  |
| `enum`                          |  |
| `eventually`                    |  |
| `final`                         |  |
| `for`                           |  |
| `function`                      |  |
| `generate`                      |  |
| `genvar`                        |  |
| `if`                            |  |
| `initial`                       |  |
| `inout`                         |  |
| `input`                         |  |
| `int`                           |  |
| `integer`                       |  |
| `interface`                     |  |
| `localparam`                    |  |
| `logic`                         |  |
| `longint`                       |  |
| `modport`                       |  |
| `module`                        |  |
| `negedge`                       |  |
| `or`                            |  |
| `output`                        |  |
| `package`                       |  |
| `packed`                        |  |
| `parameter`                     |  |
| `posedge`                       |  |
| `priority`                      |  |
| `property`                      |  |
| `rand`                          |  |
| `real`                          |  |
| `reg`                           |  |
| `repeat`                        |  |
| `restrict`                      |  |
| `s_eventually`                  |  |
| `shortint`                      |  |
| `signed`                        |  |
| `specify`                       |  |
| `specparam`                     |  |
| `struct`                        |  |
| `task`                          |  |
| `typedef`                       |  |
| `union`                         |  |
| `unique`                        |  |
| `unique0`                       |  |
| `unsigned`                      |  |
| `var`                           |  |
| `wand`                          |  |
| `while`                         |  |
| `wire`                          |  |
| `wor`                           |  |
| `/* synopsys translate_on */`   |  |
| `/* synthesis translate_on */`  |  |
| `/* synopsys translate_off */`  |  |
| `/* synthesis translate_off */` |  |
| `/* synopsysNone`               |  |
| `/* synthesisNone`              |  |
| `$display`                      |  |
| `$write`                        |  |
| `$strobe`                       |  |
| `$monitor`                      |  |
| `$time`                         |  |
| `$stop`                         |  |
| `$finish`                       |  |
| `$dumpfile`                     |  |
| `$dumpvars`                     |  |
| `$dumpon`                       |  |
| `$dumpoff`                      |  |
| `$dumpall`                      |  |
| `$info`                         |  |
| `$warning`                      |  |
| `$error`                        |  |
| `$fatal`                        |  |
| `$setup`                        |  |
| `$hold`                         |  |
| `$setuphold`                    |  |
| `$removal`                      |  |
| `$recovery`                     |  |
| `$recrem`                       |  |
| `$skew`                         |  |
| `$timeskew`                     |  |
| `$fullskew`                     |  |
| `$nochange`                     |  |
| `$signed`                       |  |
| `$unsigned`                     |  |
