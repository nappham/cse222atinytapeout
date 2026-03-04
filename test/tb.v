`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_alu user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  initial begin
    ena   = 1;
    rst_n = 1;
    clk   = 0;
    #10;

    // ADD: 3 + 2 = 5
    ui_in = 8'b0011_0010; uio_in = 8'b000; #10;
    $display("ADD 3+2 = %0d (expect 5)", uo_out);

    // SUB: 5 - 3 = 2
    ui_in = 8'b0101_0011; uio_in = 8'b001; #10;
    $display("SUB 5-3 = %0d (expect 2)", uo_out);

    // AND: 6 & 3 = 2
    ui_in = 8'b0110_0011; uio_in = 8'b010; #10;
    $display("AND 6&3 = %0d (expect 2)", uo_out);

    // OR: 5 | 2 = 7
    ui_in = 8'b0101_0010; uio_in = 8'b011; #10;
    $display("OR  5|2 = %0d (expect 7)", uo_out);

    // XOR: 5 ^ 3 = 6
    ui_in = 8'b0101_0011; uio_in = 8'b100; #10;
    $display("XOR 5^3 = %0d (expect 6)", uo_out);

    // NOT: ~3 = 252
    ui_in = 8'b0011_0000; uio_in = 8'b101; #10;
    $display("NOT ~3  = %0d (expect 252)", uo_out);

    // SHL: 3 << 1 = 6
    ui_in = 8'b0011_0000; uio_in = 8'b110; #10;
    $display("SHL 3<<1 = %0d (expect 6)", uo_out);

    // SHR: 4 >> 1 = 2
    ui_in = 8'b0100_0000; uio_in = 8'b111; #10;
    $display("SHR 4>>1 = %0d (expect 2)", uo_out);

    $finish;
  end

endmodule
