// ============================================================
// BASE SEQUENCE
// ============================================================

class mem_base_sequence extends uvm_sequence #(mem_tx);

  `uvm_object_utils(mem_base_sequence)

  uvm_phase phase;

  function new(string name = "mem_base_sequence");
    super.new(name);
  endfunction

  task pre_body();

    phase = get_starting_phase();

    if (phase != null)
      phase.raise_objection(this);
    
    tb_top.reset_dut(); // reset applied now 

  endtask


  task post_body();

    if (phase != null)
      phase.drop_objection(this);

  endtask

endclass



// ============================================================
// WRITE-READ SEQUENCE
// ============================================================


class mem_1_wr_1_rd_seq extends mem_base_sequence;
  
  mem_tx tx_1;
  
 `uvm_object_utils(mem_1_wr_1_rd_seq)
  
   function new(string name = "mem_sequence");
    super.new(name);
  endfunction
  
  task body();
    
    
    //write 
    
      req=new();
      start_item(req);

      assert(req.randomize() with {
        wr_rd_i == 1;
      });
    
      tx_1=new req;

      finish_item(req);
    
    //read 
    
       
     req=new();
     start_item(req);
    
     assert(req.randomize() with {
        wr_rd_i == 0; addr_i==tx_1.addr_i;
      });
    
      finish_item(req);
     
    
  endtask
  
  
endclass 

class mem_n_wr_n_rd_seq extends mem_base_sequence;

  mem_tx tx_1, tx_2, tx_Q[$];
  
  int num_tx;
    

  `uvm_object_utils(mem_n_wr_n_rd_seq)

  function new(string name = "mem_sequence");
    super.new(name);
  endfunction


  task body();
    
    uvm_resource_db#(int)::read_by_name("*", "num_of_iterations",num_tx, this);

    // --------------------------------------------------------
    // WRITE
    // --------------------------------------------------------

    req = new();

    repeat (num_tx) begin

      start_item(req);

      assert(req.randomize() with {
        wr_rd_i == 1;
      });

      tx_1 = new req;
      tx_Q.push_back(tx_1);

      finish_item(req);

    end


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
    // READ
    // --------------------------------------------------------

    repeat (num_tx) begin

      tx_2 = tx_Q.pop_front();

      req = new();

      start_item(req);

      assert(req.randomize() with {
        wr_rd_i == 0;
        addr_i  == tx_2.addr_i;
      });

      finish_item(req);

    end

  endtask

endclass
