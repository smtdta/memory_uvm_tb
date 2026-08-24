class mem_agent extends uvm_agent;
  
   mem_sequencer sqr_o;
   mem_driver    drv_o;
   mem_monitor   mon_o;
   mem_coverage  cov_o;
  
 //factory reg 
  
  `uvm_component_utils(mem_agent)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  //phases
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr_o=mem_sequencer::type_id::create("sqr_o",this);
    drv_o=mem_driver::type_id::create("drv_o",this);
    mon_o=mem_monitor::type_id::create("mon_o",this);
    cov_o=mem_coverage::type_id::create("cov_o",this);
  endfunction 
  
  
endclass