class mem_sequence extends uvm_sequence #(mem_tx);
  
  `uvm_object_utils(mem_sequence)
  
   function new(string name = "mem_sequence");
    super.new(name);
  endfunction
  
  task body();
    //mem_tx req;// by default
    /*req=new();
    assert(req.randomize() with {wr_rd_i==1;});
    $display("FROM SEQUENCE");
    req.print(); // note no print method was declared in mem_tx  */
    
    req=new();
    start_item(req);
    assert(req.randomize with {wr_rd_i==1;});
    finish_item(req);
    $display("FROM SEQUENCE");
    req.print(); // note no print method was declared in mem_tx  */
    
  endtask
  
endclass