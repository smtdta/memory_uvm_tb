class mem_tx extends uvm_sequence_item;

  rand bit [`ADDR_WIDTH-1:0] addr_i;
  rand bit [`WIDTH-1:0]      wdata_i;
  rand bit                   wr_rd_i;

       bit [`WIDTH-1:0]      rdata_o;

  `uvm_object_utils_begin(mem_tx)
    `uvm_field_int(addr_i,  UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(wdata_i, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(wr_rd_i, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(rdata_o, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "mem_tx");
    super.new(name);
  endfunction
  
  constraint read_wdata_c {
  !wr_rd_i -> wdata_i == '0;
}

endclass