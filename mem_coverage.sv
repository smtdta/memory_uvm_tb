class mem_coverage extends uvm_subscriber #(mem_tx);
  
  //factory reg 
  
  `uvm_component_utils(mem_coverage)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void write(mem_tx t);
    
  endfunction 
  
endclass