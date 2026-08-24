class mem_monitor extends uvm_monitor;
  
  //factory reg 
  
  `uvm_component_utils(mem_monitor)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass