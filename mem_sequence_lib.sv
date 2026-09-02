// ============================================================
// BASE SEQUENCE
// ============================================================

class mem_base_sequence extends uvm_sequence #(mem_tx);

  `uvm_object_utils(mem_base_sequence)

  uvm_phase phase;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_base_sequence");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Pre-Body
  // ----------------------------------------------------------
  task pre_body();

    phase = get_starting_phase();

    if (phase != null)
      phase.raise_objection(this);

    // Reset DUT before starting stimulus
    tb_top.reset_dut();

  endtask


  // ----------------------------------------------------------
  // Post-Body
  // ----------------------------------------------------------
  task post_body();

    if (phase != null)
      phase.drop_objection(this);

  endtask

endclass



// ============================================================
// 1 WRITE - 1 READ SEQUENCE
// ============================================================

class mem_1_wr_1_rd_seq extends mem_base_sequence;

  `uvm_object_utils(mem_1_wr_1_rd_seq)

  mem_tx tx_1;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_1_wr_1_rd_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    // --------------------------------------------------------
    // WRITE
    // --------------------------------------------------------

    req = new();

    start_item(req);

    assert(req.randomize() with {
      wr_rd_i == 1;
    });

    // Save the write transaction for the following read
    tx_1 = new req;

    finish_item(req);


    // --------------------------------------------------------
    // READ
    // --------------------------------------------------------

    req = new();

    start_item(req);

    assert(req.randomize() with {
      wr_rd_i == 0;
      addr_i  == tx_1.addr_i;
    });

    finish_item(req);

  endtask

endclass



// ============================================================
// N WRITE - N READ SEQUENCE
// Pattern: WR WR WR ... RD RD RD ...
// ============================================================

class mem_n_wr_n_rd_seq extends mem_base_sequence;

  `uvm_object_utils(mem_n_wr_n_rd_seq)

  mem_tx tx_1;
  mem_tx tx_2;
  mem_tx tx_Q[$];

  // Number of write/read iterations
  int num_tx;

  // Cyclic random address
  randc bit [`ADDR_WIDTH-1:0] addr;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_n_wr_n_rd_seq");
    super.new(name);

    // Prevent automatic randomization when started as a
    // type-based default sequence. This preserves the randc
    // cycle for the explicit randomize() calls in body().
    do_not_randomize = 1;
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    uvm_resource_db#(int)::read_by_name(
      "*",
      "num_of_iterations",
      num_tx,
      this
    );


    // --------------------------------------------------------
    // WRITE PHASE
    // --------------------------------------------------------

    repeat (num_tx) begin

      // Generate next cyclic address
      assert(this.randomize());

      `uvm_do_with(req, {
        wr_rd_i == 1;
        addr_i  == local::addr;
      })

      // Store a copy of the write transaction
      tx_1 = new req;
      tx_Q.push_back(tx_1);

    end


    // --------------------------------------------------------
    // DISPLAY STORED TRANSACTIONS
    // --------------------------------------------------------

    foreach (tx_Q[i]) begin

      $display(
        "tx_Q[%0d] addr_i=%0d wdata_i=%0h wr_rd_i=%0b",
        i,
        tx_Q[i].addr_i,
        tx_Q[i].wdata_i,
        tx_Q[i].wr_rd_i
      );

    end


    // --------------------------------------------------------
    // READ PHASE
    // --------------------------------------------------------

    repeat (num_tx) begin

      // Retrieve the corresponding stored write transaction
      tx_2 = tx_Q.pop_front();

      `uvm_do_with(req, {
        wr_rd_i == 0;
        addr_i  == tx_2.addr_i;
      })

    end

  endtask

endclass



// ============================================================
// 1 WRITE SEQUENCE
// ============================================================

class mem_wr_seq extends mem_base_sequence;

  `uvm_object_utils(mem_wr_seq)

  rand bit [`ADDR_WIDTH-1:0] addr_wr;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_wr_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    `uvm_do_with(req, {
      wr_rd_i == 1;
      addr_i  == local::addr_wr;
    })

  endtask

endclass



// ============================================================
// 1 READ SEQUENCE
// ============================================================

class mem_rd_seq extends mem_base_sequence;

  `uvm_object_utils(mem_rd_seq)

  rand bit [`ADDR_WIDTH-1:0] addr_rd;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_rd_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    `uvm_do_with(req, {
      wr_rd_i == 0;
      addr_i  == local::addr_rd;
    })

  endtask

endclass



// ============================================================
// WRITE - READ LAYERED SEQUENCE 1
// Pattern: WR RD WR RD WR RD ...
// ============================================================

class mem_wr_rd_seq extends mem_base_sequence;

  `uvm_object_utils(mem_wr_rd_seq)

  // Lower-level sequence handles
  mem_wr_seq wr;
  mem_rd_seq rd;

  // Number of write-read iterations
  int num_tx;

  // Upper-layer cyclic random address
  randc bit [`ADDR_WIDTH-1:0] addr;

  // Queue used to store generated addresses for debug
  bit [`ADDR_WIDTH-1:0] addr_q[$];


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "mem_wr_rd_seq");
    super.new(name);

    // Prevent automatic randomization when started as a
    // type-based default sequence. This preserves the randc
    // cycle for the explicit randomize() calls in body().
    do_not_randomize = 1;
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    uvm_resource_db#(int)::read_by_name(
      "*",
      "num_of_iterations",
      num_tx,
      this
    );

    $display("BEFORE LOOP: addr = %0d", addr);

    repeat (num_tx) begin

      // Generate next cyclic address
      assert(this.randomize());

      $display(
        "AFTER RANDOMIZE: addr=%0d",
        addr
      );

      // Store generated address for debug
      addr_q.push_back(this.addr);

      // Write to generated address
      `uvm_do_with(wr, {
        addr_wr == local::addr;
      })

      // Read from the same generated address
      `uvm_do_with(rd, {
        addr_rd == local::addr;
      })

    end

  endtask


  // ----------------------------------------------------------
  // Post-Body
  // ----------------------------------------------------------
  task post_body();

    // Debug: sort and display all generated addresses
    addr_q.sort();

    $display(
      "addr_q=%p",
      addr_q
    );

    // Call base post_body() to drop the phase objection
    super.post_body();

  endtask

endclass



// ============================================================
// WRITE - READ LAYERED SEQUENCE 2
// Pattern: WR WR WR ... RD RD RD ...
// ============================================================

class wr_rd_seq_layer_2 extends mem_base_sequence;

  `uvm_object_utils(wr_rd_seq_layer_2)

  // Upper-layer cyclic random write address
  randc bit [`ADDR_WIDTH-1:0] addr_2;

  // Address used to replay stored write addresses during reads
  bit [`ADDR_WIDTH-1:0] rd_addr_2;

  // Queue storing write addresses for the later read phase
  bit [`ADDR_WIDTH-1:0] addr_q[$];

  // Lower-level sequence handles
  mem_wr_seq wr_o;
  mem_rd_seq rd_o;

  // Number of write/read iterations
  int num_itr;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "wr_rd_seq_layer_2");
    super.new(name);

    // Prevent automatic randomization when started as a
    // type-based default sequence. This preserves the randc
    // cycle for the explicit randomize() calls in body().
    do_not_randomize = 1;
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    uvm_resource_db#(int)::read_by_name(
      "*",
      "num_of_iterations",
      num_itr,
      this
    );


    // --------------------------------------------------------
    // WRITE PHASE
    // --------------------------------------------------------

    repeat (num_itr) begin

      // Generate next cyclic write address
      assert(this.randomize());

      // Store address for the later read phase
      addr_q.push_back(this.addr_2);

      // Pass generated address to the lower-level write sequence
      `uvm_do_with(wr_o, {
        addr_wr == addr_2;
      })

    end


    // --------------------------------------------------------
    // READ PHASE
    // --------------------------------------------------------

    repeat (num_itr) begin

      // Retrieve addresses in the same order they were written
      rd_addr_2 = addr_q.pop_front();

      // Pass stored address to the lower-level read sequence
      `uvm_do_with(rd_o, {
        addr_rd == rd_addr_2;
      })

    end

  endtask

endclass