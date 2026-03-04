import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.clk.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(10, units="ns")

    # ADD: 3 + 2 = 5
    dut.ui_in.value  = 0b00110010
    dut.uio_in.value = 0b000
    await Timer(10, units="ns")
    assert dut.uo_out.value == 5, f"ADD failed: {dut.uo_out.value}"

    # SUB: 5 - 3 = 2
    dut.ui_in.value  = 0b01010011
    dut.uio_in.value = 0b001
    await Timer(10, units="ns")
    assert dut.uo_out.value == 2, f"SUB failed: {dut.uo_out.value}"

    # AND: 6 & 3 = 2
    dut.ui_in.value  = 0b01100011
    dut.uio_in.value = 0b010
    await Timer(10, units="ns")
    assert dut.uo_out.value == 2, f"AND failed: {dut.uo_out.value}"

    dut._log.info("All tests passed!")
