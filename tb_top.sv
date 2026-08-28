`include "uvm_macros.svh"
`include "uvm_pkg.sv"
 import uvm_pkg::*;
   
`include "mem_defines.sv"
   
 module tb_top;
   
   logic clk_i,rst_i;
   
   //interface instance 
   mem_interface #(`WIDTH,`DEPTH) pif (clk_i,rst_i);
   
   //DUT instance 
   
  memory #(
  .WIDTH(`WIDTH),
  .DEPTH(`DEPTH)
) mem_dut (
  .clk_i   (pif.clk_intf),
  .rst_i   (pif.rst_intf),
  .valid_i (pif.valid_intf),
  .wr_rd_i (pif.wr_rd_intf),
  .addr_i  (pif.addr_intf),
  .wdata_i (pif.wdata_intf),
  .rdata_o (pif.rdata_intf),
  .ready_o (pif.ready_intf)
);
   
   
   //clk_rst gen
   
   always #5 clk_i=~clk_i;
   
   task reset_dut();

      rst_i = 1'b1;
      pif.valid_intf = 1'b0;
      pif.wr_rd_intf = 1'b0;
      pif.addr_intf  = '0;
      pif.wdata_intf = '0;

      repeat (2) @(posedge clk_i);

      rst_i = 1'b0;
     
      @(posedge clk_i);

   endtask
   
   
   
   initial
     begin
      // mem_common::vif = pif;
       uvm_resource_db#( virtual mem_interface#(`WIDTH, `DEPTH) )::set("*","vif",pif,null);
       clk_i=0;     
       run_test("mem_1_wr_1_rd_test");  
     end
   
   //vcd dump 
   
   initial 
     begin
       $dumpfile("uvm_mem_tb.vcd");
       $dumpvars(0,tb_top);     
     end
   
 endmodule