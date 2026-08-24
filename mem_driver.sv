class mem_driver extends uvm_driver #(mem_tx);
  
  //factory reg 
  
  `uvm_component_utils(mem_driver)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      $display("FROM DRIVER");
      req.print();
      seq_item_port.item_done();     
    end
    
  endtask
  
endclass