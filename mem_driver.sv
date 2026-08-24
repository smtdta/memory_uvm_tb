class mem_driver extends uvm_driver #(mem_tx);
  
  //factory reg 
  
  `uvm_component_utils(mem_driver)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass