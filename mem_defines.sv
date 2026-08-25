`ifndef MEM_DEFINES_SV
`define MEM_DEFINES_SV

`define WIDTH      16
`define DEPTH      8
`define ADDR_WIDTH $clog2(`DEPTH)

`endif


`include "mem_interface.sv"
`include "mem_common.sv"
`include "memory.v"

`include "mem_tx.sv"
`include "mem_sequencer.sv"
`include "mem_driver.sv"
`include "mem_monitor.sv"
`include "mem_coverage.sv"
`include "mem_agent.sv"
`include "mem_env.sv"
`include "mem_sequence.sv"
`include "mem_base_test.sv"