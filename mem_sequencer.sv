class mem_sequencer extends uvm_sequencer #(mem_tx);
  
  //factory reg 
  
  `uvm_component_utils(mem_sequencer)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass