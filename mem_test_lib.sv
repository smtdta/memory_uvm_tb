// ============================================================
// BASE TEST
// ============================================================

class mem_base_test extends uvm_test;

  // ----------------------------------------------------------
  // Handles
  // ----------------------------------------------------------
  mem_env           env_o;
 // mem_base_sequence seq_o; //no need now


  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(mem_base_test)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_base_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create environment
    env_o = mem_env::type_id::create("env_o", this);

    // Common configuration
    uvm_resource_db#(int)::set(
      "*",
      "num_of_iterations",
      8,
      this
    );

  endfunction

  
  /* //no need now

  // ----------------------------------------------------------
  // Run Phase
  // ----------------------------------------------------------
  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    // Reset DUT before starting stimulus
    tb_top.reset_dut();

    // Child test must create the required sequence
    if (seq_o == null)
      `uvm_fatal("NO_SEQ",
                 "No sequence created by the test")

    // Start selected sequence on memory sequencer
    seq_o.start(env_o.agent_o.sqr_o);

    // Allow outstanding activity to complete
    phase.phase_done.set_drain_time(this, 200ns);

    phase.drop_objection(this);

  endtask
*/

  // ----------------------------------------------------------
  // End of Elaboration Phase
  // ----------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();

  endfunction


  // ----------------------------------------------------------
  // Report Phase
  // ----------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    $display("======================================");
    $display("MEMORY COVERAGE = %0.2f%%",
             env_o.agent_o.cov_o.mem_cg.get_coverage());
    $display("======================================");

  endfunction

endclass


// ============================================================
// 1 WRITE - 1 READ TEST
// ============================================================

class mem_1_wr_1_rd_test extends mem_base_test;

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(mem_1_wr_1_rd_test)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_1_wr_1_rd_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Select sequence for this test
    //seq_o = mem_1_wr_1_rd_seq::type_id::create("seq_o");
    
    uvm_config_db#(uvm_object_wrapper)::set(
        this,
        "env_o.agent_o.sqr_o.run_phase",
        "default_sequence",
        mem_1_wr_1_rd_seq::get_type()
    );

  endfunction

endclass



// ============================================================
// N WRITE - N READ TEST
// ============================================================

class mem_n_wr_n_rd_test extends mem_base_test;

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(mem_n_wr_n_rd_test)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_n_wr_n_rd_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Select sequence for this test
   // seq_o = mem_n_wr_n_rd_seq::type_id::create("seq_o");
    
    uvm_config_db#(uvm_object_wrapper)::set(
        this,
        "env_o.agent_o.sqr_o.run_phase",
        "default_sequence",
        mem_n_wr_n_rd_seq::get_type()
    );

  endfunction 

endclass



// ============================================================
// Seq Layered Test
// ============================================================

class mem_wr_rd_test extends mem_base_test;
  
  `uvm_component_utils(mem_wr_rd_test)
  
  function new(string name = "",uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Select sequence for this test
    //seq_o = mem_1_wr_1_rd_seq::type_id::create("seq_o");
    
    uvm_config_db#(uvm_object_wrapper)::set(
        this,
        "env_o.agent_o.sqr_o.run_phase",
        "default_sequence",
         wr_rd_seq_layer_2::get_type()
    );

  endfunction
  
endclass

