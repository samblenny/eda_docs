#!/usr/bin/python3
"""\
Gather tokens from the Yosys Verilog frontend lexer specification.

The point of this script is to emit a partially populated Markdown table of
Verilog tokens specified in `yosys/frontends/verilog/verilog_lexer.l`. The
point of making the table is to help with documentating the subsets of Verilog
and SystemVerilog that Yosys supports.

Usage:

    python3 gather_tokens.py $PATH_TO_YOSYS/frontends/verilog/verilog_lexer.l

"""
from subprocess import Popen, PIPE
import re
import sys
import os

def run(cmd, ps=None):
    in_pipe = None if ps==None else ps.stdout
    return Popen(cmd, stdin=in_pipe, stdout=PIPE)

def clean(line):
    # Match stuff like: '"/*"[ \t]*(synopsys|synthesis)[ \t]+ {'
    comment_open = r'"/\*"\[ \\t\]\*'
    funcs = r'\((.*)\)\[ \\t\][\+\*]'
    flag = r'(?:"?([A-Za-z_]+)"?)?'
    tail = r'(?:\[ \\t\][\+\*])?"?(\*/|.*)?"? {'
    match = re.search(comment_open + funcs + flag + tail, line)
    if match:
        options = match.group(1).split("|")
        suffix = match.group(2) and " "+match.group(2)+" "+match.group(3)
        lexemes = ["`/* {}{}`".format(opt, suffix) for opt in options]
        lines = ["| {:31} |  |".format(lexeme) for lexeme in lexemes]
        return "\n".join(lines)
    # Match multi-token patterns like: '"$"(setup|hold|...) {'
    match = re.search('"\$"\((.*)\) {', line)
    if match:
        lexemes = ["`${}`".format(id) for id in match.group(1).split("|")]
        lines = ["| {:31} |  |".format(lexeme) for lexeme in lexemes]
        return "\n".join(lines)
    # Match single string per token patterns
    match = re.search('"(.*)".*TOK_', line)
    if match:
        lexeme = "`{}`".format(match.group(1))
        return "| {:31} |  |".format(lexeme)
    # Pass through un-recognized lines
    return line

if len(sys.argv) == 2:
    # Do the equivalent of: egrep ... | sort | uniq
    p1 = run(["egrep", '"`?[^"]{1,30}".*(TOK_|\|)', sys.argv[1]])
    p2 = run(["sort"], ps=p1)
    p3 = run(["uniq"], ps=p2)
    #p4 = run(["sed", r's/"[^"]*TOK_\([A-Z_]*\).*/" \1/'], ps=p3)
    out = p3.communicate()[0].decode("utf-8").strip()
    print("| {:31} | {:11} |".format("Lexeme", "Description"))
    print("|-{}-|-{}-|".format(31*"-", 11*"-"))
    for line in out.split("\n"):
        print(clean(line))
else:
    print(globals()['__doc__'], end="")
