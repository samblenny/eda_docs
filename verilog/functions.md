# Yosys Verilog Functions & System Tasks

This page attempts to document Verilog functions and system tasks that Yosys
knows how to parse.

The lists of names come from grepping `yosys/frontends/ast/simplify.cc`. The
descriptions are my best guess based on reading the code in `simplify.cc`,
reading the yosys README, and cross checking against the IEEE 1364-2005 Verilog
standard.


## Standard System Tasks

| Function                                                  | Description                                                     |
|-----------------------------------------------------------|-----------------------------------------------------------------|
| `$readmemb(file, memory [, start_addr [, finish_addr]])`  | 17.2.9: read binary formatted data from text file into a memory |
| `$readmemh(file, memory [, start_addr [, finish_addr]])`  | 17.2.9: read hexadecimal formatted data from text file into a memory |
| `$finish[(n)]`                                            | 17.4: exit simulator; optional `n` (0..2) controls printing of diagnostic stats |
| `$stop[(n)]`                                              | 17.4: suspend simulation; optional `n` (0..2) controls printing of diagnostic stats |
| `$write(format_string [, args...])`                       | 17.1: display `args` in the format specified by `format_string` |
| `$display(format_string [, args...])`                     | 17.1: like `$write`, but with an automatic newline |
| `$strobe(format_string, $time [, args...])`               | 17.1.2: like `$display`, but triggered at a specific time |
| `$monitor(format_string [, args...])`                     | 17.1.3: like `$display`, but triggered when `args` change |
| `uint64 $time`                                            | 17.7.1: returns simulated time as 64-bit integer, scaled to module's timescale |


## Standard Math Functions

| Function                   | Description                       |
|----------------------------|-----------------------------------|
| `real $itor(int n)`        | 17.8: convert integer `n` to real |
| `int  $rtoi(real n)`       | 17.8: truncate real `n` to integer |
| `int  $clog2(const int n)` | 17.11: ceiling of base-2 log of `n` |
| `real $acos(real x)`       | 17.11: arc-cosine of x |
| `real $acosh(real x)`      | 17.11: arc-hyperbolic cosine of x |
| `real $asin(real x)`       | 17.11: arc-sine of x |
| `real $asinh(real x)`      | 17.11: arc-hyperbolic sine of x |
| `real $atan(real x)`       | 17.11: arc-tangent of x |
| `real $atan2(real x,y)`    | 17.11: arc-tangent of x/y |
| `real $atanh(real x)`      | 17.11: arc-hyperbolic tangent of x |
| `real $cos(real x)`        | 17.11: cosine of x |
| `real $cosh(real x)`       | 17.11: hyperbolic cosine of x |
| `real $exp(real x)`        | 17.11: e^x |
| `real $ceil(real x)`       | 17.11: ceiling of x |
| `real $floor(real x)`      | 17.11: floor of x |
| `real $hypot(real x,y)`    | 17.11: sqare root of x^2 + y^2 |
| `real $ln(real x)`         | 17.11: natural log of x |
| `real $log10(real x)`      | 17.11: base-10 log of x |
| `real $pow(real x,y)`      | 17.11: x^y |
| `real $sin(real x)`        | 17.11: sine of x |
| `real $sinh(real x)`       | 17.11: hyperbolic sine of x |
| `real $sqrt(real x)`       | 17.11: square root of x |
| `real $tan(real x)`        | 17.11: tangent of x |
| `real $tanh(real x)`       | 17.11: hyperbolic tangent of x |


## SystemVerilog Functions

Yosys supports some SystemVerilog functions. Descriptions here are my best
guess based on reading the code and cross-checking with IEEE 1800-2017.

| Function                                               | Description             |
|--------------------------------------------------------|-------------------------|
| `int $bits(expr_or_type)`                              | 20.6.2: number of bits required to hold expression or type |
| `int $left(expr_or_type [, dimension_expr=1])`         | 20.7: left bound of expression's dimension |
| `int $right(expr_or_type [, dimension_expr=1])`        | 20.7: right bound of expression's dimension |
| `int $low(expr_or_type [, dimension_expr=1])`          | 20.7: lesser bound of dimension = `($left < $right) ? $left : $right` |
| `int $high(expr_or_type [, dimension_expr=1])`         | 20.7: greater bound of dimension = `($left < $right) ? $right : $left` |
| `int $size(expr_or_type [, dimension_expr=1])`         | 20.7: number of elements in dimension =`$high - $low + 1` |
| `int $countbits(expr, control_bit [, control_bit...])` | 20.9: count of bits in expression matching one of the control bits ('0, '1, 'x, 'z) |
| `int $countones(expr)`                                 | 20.9: equivalent to `$countbits(expr,'1)` |
| `int (1'b) $onehot(expr)`                              | 20.9: equivalent to `$countbits(expr,'1)==1` |
| `int $onehot0(expr)`                                   | 20.9: equivalent to `$countbits(expr,'1)<=1` |
| `int $isunknown(expr)`                                 | 20.9: equivalent to `$countbits(expr,'x,'z)!=0` |
| `$changed(node)`                                       | 20.13: `$past(node) != node` |
| `$fell(node)`                                          | 20.13: `($past(node)&1) & (~(node&1))` |
| `$past(node, num_steps=1)`                             | 20.13: value of `node` at `num_steps` clocks in the past |
| `$rose(node)`                                          | 20.13: `(~($past(node)&1)) & (node&1)` |
| `$stable(node)`                                        | 20.13: `$past(node) == node` |


## Non-Standard Functions

Yosys includes non-standard functions and attributes for formal verification
and other purposes. See
https://github.com/YosysHQ/yosys#non-standard-or-systemverilog-features-for-formal-verification
and
https://github.com/YosysHQ/yosys#verilog-attributes-and-non-standard-features

| Function                   | Description             |
|----------------------------|-------------------------|
| `$initstate`               | (initial state) ? 1 : 0 |
| `$allconst`                | for use in formal verification |
| `$allseq`                  | for use in formal verification |
| `$anyconst`                | any constant value |
| `$anyseq`                  | any value |
| `$global_clock`            | something to do with making specially configured flip flops |
| `$sformatf()`              | ? |
| `$dumpall()`               | ? |
| `$dumpfile()`              | ? |
| `$dumpoff()`               | ? |
| `$dumpon()`                | ? |
| `$dumpvars()`              | ? |


## Grepping the Verilog front-end

This procedure finds Verilog functions in the Yosys source code.

Start with the yosys source:
```
$ git remote -v
origin	https://github.com/YosysHQ/yosys.git (fetch)
origin	https://github.com/YosysHQ/yosys.git (push)
$ git branch
* master
$ git rev-parse HEAD
438bcc68c0859057e4d3f521d1c865d2a9d90e15
```


### Grep for Functions

Grep the parsing code for string match expressions like `if (str == "\\$clog2")`:

```
$ grep -o '"\\\\$[^"]\+"' frontends/ast/simplify.cc | sort | uniq | grep -o '$[^"]*'
$acos
$acosh
$allconst
$allseq
$anyconst
$anyseq
$asin
$asinh
$atan
$atan2
$atanh
$bits
$ceil
$changed
$clog2
$cos
$cosh
$countbits
$countones
$exp
$fell
$floor
$global_clock
$high
$hypot
$initstate
$isunknown
$itor
$left
$ln
$log10
$low
$onehot
$onehot0
$past
$pow
$readmemb
$readmemh
$right
$rose
$rtoi
$sformatf
$sin
$sinh
$size
$sqrt
$stable
$tan
$tanh
```


### Grep for System Tasks

Grep the parsing code for string match expressions like `if (str == "$display")`:

```
$ grep -o '"$[^"]\+"' frontends/ast/simplify.cc | sort | uniq | grep -o '$[^"]*'
$array:%d:%d:%s
$bitselwrite$data$%s:%d$%d
$bitselwrite$mask$%s:%d$%d
$display
$dumpall
$dumpfile
$dumpoff
$dumpon
$dumpvars
$finish
$formal$
$func$
$initstate
$initstate$%d
$initstate$%d_wire
$mem2bits$
$mem2reg_rd$
$mem2reg_wr$
$memwr$
$monitor
$past$%s:%d$%d$%d
$result
$splitcmplxassign$%s:%d$%d
$stop
$strobe
$time
$write
```
