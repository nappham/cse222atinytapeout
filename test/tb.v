`default_nettype none
`timescale 1ns / 1ps

module tb ();

  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

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

  tt_um_alu user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk   = 0;
    ena   = 1;
    rst_n = 0;
    ui_in  = 0;
    uio_in = 0;
    #50;           // hold reset for 50ns
    rst_n = 1;
    #20;           // settle after reset

    // ADD: 3 + 2 = 5
    ui_in = 8'b0011_0010; uio_in = 8'b000; #20;
    $display("ADD 3+2 = %0d (expect 5)", uo_out);

    // SUB: 5 - 3 = 2
    ui_in = 8'b0101_0011; uio_in = 8'b001; #20;
    $display("SUB 5-3 = %0d (expect 2)", uo_out);

    // AND: 6 & 3 = 2
    ui_in = 8'b0110_0011; uio_in = 8'b010; #20;
    $display("AND 6&3 = %0d (expect 2)", uo_out);

    // OR: 6 | 3 = 7
    ui_in = 8'b0110_0011; uio_in = 8'b011; #20;
    $display("OR  6|3 = %0d (expect 7)", uo_out);

    // XOR: 6 ^ 3 = 5
    ui_in = 8'b0110_0011; uio_in = 8'b100; #20;
    $display("XOR 6^3 = %0d (expect 5)", uo_out);

    // NOT: ~6 = 1001 = 9 (4-bit)
    ui_in = 8'b0110_0000; uio_in = 8'b101; #20;
    $display("NOT ~6  = %0d (expect 9)", uo_out);

    // SHL: 3 << 1 = 6
    ui_in = 8'b0011_0000; uio_in = 8'b110; #20;
    $display("SHL 3<<1 = %0d (expect 6)", uo_out);

    // SHR: 6 >> 1 = 3
    ui_in = 8'b0110_0000; uio_in = 8'b111; #20;
    $display("SHR 6>>1 = %0d (expect 3)", uo_out);

    $finish;
  end

endmodule
