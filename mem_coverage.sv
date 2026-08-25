class mem_coverage extends uvm_subscriber #(mem_tx);
  
    mem_tx tx;

  `uvm_component_utils(mem_coverage)

  // Coverage group
  covergroup mem_cg;

    ADDR_CP: coverpoint tx.addr_i {
      bins ADDR[] = {[0:`DEPTH-1]};
    }

    WR_RD_CP: coverpoint tx.wr_rd_i {
      bins WRITE = {1'b1};
      bins READ  = {1'b0};
    }

    ADDR_X_WRRD: cross ADDR_CP, WR_RD_CP;

  endgroup


  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);

    mem_cg = new();
  endfunction


  virtual function void write(mem_tx t);

    $cast(tx, t);

    //$display("COVERAGE GOT TRANSACTION");
    //tx.print();

    mem_cg.sample();

  endfunction

endclass