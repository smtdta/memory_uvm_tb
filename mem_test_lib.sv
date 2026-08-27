class mem_base_test extends uvm_test;

  mem_env env_o;

  // Factory registration
  `uvm_component_utils(mem_base_test)

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Phases
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_o = mem_env::type_id::create("env_o", this);

    uvm_resource_db#(int)::set("*", "num_of_iterations", 5, this);
  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction


  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();
  endfunction


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    $display("======================================");
    $display("MEMORY COVERAGE = %0.2f%%",
             env_o.agent_o.cov_o.mem_cg.get_coverage());
    $display("======================================");
  endfunction

endclass



class mem_1_wr_1_rd_test extends mem_base_test;

  mem_1_wr_1_rd_seq wr_1_rd_1_o;

  // Factory registration
  `uvm_component_utils(mem_1_wr_1_rd_test)

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    tb_top.reset_dut();

    wr_1_rd_1_o = mem_1_wr_1_rd_seq::type_id::create("wr_1_rd_1_o");
    wr_1_rd_1_o.start(env_o.agent_o.sqr_o);

    phase.phase_done.set_drain_time(this, 200ns);

    phase.drop_objection(this);

  endtask

endclass



class mem_n_wr_n_rd_test extends mem_base_test;

  mem_n_wr_n_rd_seq wr_n_rd_n_o;

  // Factory registration
  `uvm_component_utils(mem_n_wr_n_rd_test)

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    tb_top.reset_dut();

    wr_n_rd_n_o = mem_n_wr_n_rd_seq::type_id::create("wr_n_rd_n_o");
    wr_n_rd_n_o.start(env_o.agent_o.sqr_o);

    phase.phase_done.set_drain_time(this, 200ns);

    phase.drop_objection(this);

  endtask

endclass