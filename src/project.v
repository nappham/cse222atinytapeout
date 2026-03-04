module tt_um_alu (
    input  wire [7:0] ui_in,    // A operand
    input  wire [7:0] uio_in,   // B operand or opcode
    output wire [7:0] uo_out,   // Result
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [3:0] a   = ui_in[7:4];
    wire [3:0] b   = ui_in[3:0];
    wire [2:0] op  = uio_in[2:0];
    reg  [7:0] result;

    always @(*) begin
        case (op)
            3'b000: result = a + b;        // ADD
            3'b001: result = a - b;        // SUB
            3'b010: result = a & b;        // AND
            3'b011: result = a | b;        // OR
            3'b100: result = a ^ b;        // XOR
            3'b101: result = ~a;           // NOT A
            3'b110: result = a << 1;       // Shift left
            3'b111: result = a >> 1;       // Shift right
            default: result = 8'b0;
        endcase
    end

    assign uo_out  = result;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
