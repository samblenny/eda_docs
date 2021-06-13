# eda_docs

## Experiments

- [Exp01](experiments/exp01): simple make + yosys + nextpnr build example


## Toolchain Build and Install Procedure

See [toolchain/](toolchain)


## Reference

### Tools
- Yosys (Verilog synth/sim): [docs](http://www.clifford.at/yosys/documentation.html) /
  [code](https://github.com/YosysHQ/yosys)
- Nextpnr (place & route): [docs](https://github.com/YosysHQ/nextpnr/tree/master/docs) /
  [code](https://github.com/YosysHQ/nextpnr)
- Project IceStorm (iCE40 tools): [docs](http://www.clifford.at/icestorm/) /
  [code](https://github.com/YosysHQ/icestorm)
- [YosysHQ repos](https://github.com/YosysHQ)

### iCE40
- Lattice Tech Brief:
  [Silicon Blue ICE Technology Library](http://www.latticesemi.com/~/media/LatticeSemi/Documents/TechnicalBriefs/SBTICETechnologyLibrary201504.pdf)
  (pdf with Verilog docs for `SB_IO`, `SB_I2C`, `SB_MAC16`, `SB_PLL*`, `SB_RAM*`, `SB_SPI` (p 131), etc.)
- Lattice [iCE40 UltraPlus](https://www.latticesemi.com/en/Products/FPGAandCPLD/iCE40UltraPlus)
  product page
- iCE40-UP5K:
  - Lattice [iCE40UP5K-B-EVN](https://www.latticesemi.com/products/developmentboardsandkits/ice40ultraplusbreakoutboard)
    iCE40 UltraPlus Breakout Board product page (12 MHz oscillator)
  - [iCE40UP5K-B-EVN User Guide (pdf)](https://www.latticesemi.com/view_document?document_id=51987):
    Appendix A, pages 23-29, has schematics for up5k-sg48 pinout; 12 MHz oscillator on pin 35, etc.
- iCE40-HX8K:
  - Lattice [ICE40HX8K-B-EVN](https://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/iCE40HX8KBreakoutBoard.aspx)
    iCE40-HX8K Breakout Board product page (12 MHz oscillator)
  - [iCE40HX8K-B-EVN User Guide (pdf)](https://www.latticesemi.com/view_document?document_id=50373):
    Appendix A, pages 12-17, has schematics for HX8K-CT256 pinout; 12 MHz oscillator on pin `J3`, etc.
  - Project IceStorm [icestorm/examples/hx8kboard/hx8kboard.pcf](icestorm/examples/hx8kboard/hx8kboard.pcf):
    pin configuration file (.pcf) for HX8K-CT256, which confusingly uses alphanumeric pin numers.
    Clock pin is defined as `set_io clk J3`. See the `iCE_CLK` net on pages 13 and 15 of the
    iCE40HX8K-B-EVN User Guide pdf.
