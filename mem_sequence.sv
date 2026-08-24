class mem_sequence extends uvm_sequence #(mem_tx);
  
  `uvm_object_utils(mem_sequence)
  
   function new(string name = "mem_sequence");
    super.new(name);
  endfunction
  
  task body();
    //mem_tx req;// by default
    req=new();
    assert(req.randomize() with {wr_rd_i==1;});
    req.print(); // note no print method was declared in mem_tx 
  endtask
  
endclass