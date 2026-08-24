`include "uvm_macros.svh"
`include "uvm_pkg.sv"
 import uvm_pkg::*;
   
`include "mem_tx.sv"
`include "mem_coverage.sv"
`include "mem_monitor.sv"
`include "mem_driver.sv"
`include "mem_sequencer.sv"
`include "mem_agent.sv"
`include "mem_env.sv"
`include "mem_base_test.sv"
   
 module tb_top;
   
   initial
     begin
       
       run_test("mem_base_test");
       
     end
   
 endmodule