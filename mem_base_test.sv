class mem_base_test extends uvm_test;
  
   mem_env env_o;
  
  //factory reg 
  
  `uvm_component_utils(mem_base_test)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  //phases
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o=mem_env::type_id::create("env_o",this);
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction 
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction 
  
endclass