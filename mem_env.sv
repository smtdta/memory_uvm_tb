class mem_env extends uvm_env;
  
   mem_agent agent_o;
  
 //factory reg 
  
  `uvm_component_utils(mem_env)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  //phases
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_o=mem_agent::type_id::create("agent_o",this);
  endfunction 
  
  
endclass