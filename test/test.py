import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Start clock (required for gate-level sim)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value   = 1
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # ADD: 3 + 2 = 5
    dut.ui_in.value  = 0b00110010  # a=3, b=2
    dut.uio_in.value = 0b000
    await Timer(10, units="ns")
    assert dut.uo_out.value == 5, f"ADD failed: got {dut.uo_out.value}, expected 5"

    # SUB: 5 - 3 = 2
    dut.ui_in.value  = 0b01010011  # a=5, b=3
    dut.uio_in.value = 0b001
    await Timer(10, units="ns")
    assert dut.uo_out.value == 2, f"SUB failed: got {dut.uo_out.value}, expected 2"

    # AND: 6 & 3 = 2
    dut.ui_in.value  = 0b01100011  # a=6, b=3
    dut.uio_in.value = 0b010
    await Timer(10, units="ns")
    assert dut.uo_out.value == 2, f"AND failed: got {dut.uo_out.value}, expected 2"

    # OR: 6 | 3 = 7
    dut.ui_in.value  = 0b01100011  # a=6, b=3
    dut.uio_in.value = 0b011
    await Timer(10, units="ns")
    assert dut.uo_out.value == 7, f"OR failed: got {dut.uo_out.value}, expected 7"

    # XOR: 6 ^ 3 = 5
    dut.ui_in.value  = 0b01100011  # a=6, b=3
    dut.uio_in.value = 0b100
    await Timer(10, units="ns")
    assert dut.uo_out.value == 5, f"XOR failed: got {dut.uo_out.value}, expected 5"

    # NOT A: ~6 = 0b11111001 = 249 (8-bit), but a is 4-bit so ~4'b0110 = 4'b1001 = 9
    dut.ui_in.value  = 0b01100000  # a=6, b=don't care
    dut.uio_in.value = 0b101
    await Timer(10, units="ns")
    assert dut.uo_out.value == 9, f"NOT failed: got {dut.uo_out.value}, expected 9"

    # SHL: 3 << 1 = 6
    dut.ui_in.value  = 0b00110000  # a=3, b=don't care
    dut.uio_in.value = 0b110
    await Timer(10, units="ns")
    assert dut.uo_out.value == 6, f"SHL failed: got {dut.uo_out.value}, expected 6"

    # SHR: 6 >> 1 = 3
    dut.ui_in.value  = 0b01100000  # a=6, b=don't care
    dut.uio_in.value = 0b111
    await Timer(10, units="ns")
    assert dut.uo_out.value == 3, f"SHR failed: got {dut.uo_out.value}, expected 3"

    dut._log.info("All tests passed!")
