class mem_tx extends uvm_sequence_item;
  
  //factory reg 
  
  `uvm_object_utils(mem_tx)
  
  //constructor 
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass