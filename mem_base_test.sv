class mem_base_test extends uvm_test;
  
   mem_env env_o;
   mem_sequence seq_o;
  
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
  
 task run_phase(uvm_phase phase);
   
  phase.raise_objection(this);
   
  tb_top.reset_dut();

  seq_o = mem_sequence::type_id::create("seq_o");
  seq_o.start(env_o.agent_o.sqr_o);

  phase.phase_done.set_drain_time(this, 200ns);

  phase.drop_objection(this);

 endtask
  
  function void report_phase(uvm_phase phase);

  super.report_phase(phase);

  $display("======================================");
  $display("MEMORY COVERAGE = %0.2f%%",
           env_o.agent_o.cov_o.mem_cg.get_coverage());
  $display("======================================");

endfunction

endclass