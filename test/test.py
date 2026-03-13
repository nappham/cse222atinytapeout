import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

def set_inputs(dut, a, b, op):
    dut.ui_in.value  = ((a & 0xF) << 4) | (b & 0xF)
    dut.uio_in.value = op & 0x7

async def wait_and_check(dut, expected, op_name):
    await Timer(20, unit="ns")
    got = int(dut.uo_out.value)
    assert got == expected, f"{op_name} FAILED: got {got}, expected {expected}"
    dut._log.info(f"{op_name} PASSED: got {got}")

@cocotb.test()
async def test_alu(dut):
    dut._log.info("Starting ALU tests")

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Reset - hold for longer to be safe
    dut.ena.value    = 1
    dut.rst_n.value  = 0
    dut.ui_in.value  = 0
    dut.uio_in.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    for _ in range(3):
        await RisingEdge(dut.clk)

    # ADD: 3 + 2 = 5
    set_inputs(dut, a=3, b=2, op=0b000)
    await wait_and_check(dut, 5, "ADD 3+2")

    # SUB: 5 - 3 = 2
    set_inputs(dut, a=5, b=3, op=0b001)
    await wait_and_check(dut, 2, "SUB 5-3")

    # AND: 6 & 3 = 2
    set_inputs(dut, a=6, b=3, op=0b010)
    await wait_and_check(dut, 2, "AND 6&3")

    # OR: 6 | 3 = 7
    set_inputs(dut, a=6, b=3, op=0b011)
    await wait_and_check(dut, 7, "OR 6|3")

    # XOR: 6 ^ 3 = 5
    set_inputs(dut, a=6, b=3, op=0b100)
    await wait_and_check(dut, 5, "XOR 6^3")

    # NOT: ~6 = 1001 = 9 (4-bit)
    set_inputs(dut, a=6, b=0, op=0b101)
    await wait_and_check(dut, 9, "NOT ~6")

    # SHL: 3 << 1 = 6
    set_inputs(dut, a=3, b=0, op=0b110)
    await wait_and_check(dut, 6, "SHL 3<<1")

    # SHR: 6 >> 1 = 3
    set_inputs(dut, a=6, b=0, op=0b111)
    await wait_and_check(dut, 3, "SHR 6>>1")

    dut._log.info("All ALU tests passed!")
