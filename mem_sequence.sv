class mem_sequence extends uvm_sequence #(mem_tx);

  `uvm_object_utils(mem_sequence)
  
  mem_tx tx_1,tx_2,tx_Q[$];

  function new(string name = "mem_sequence");
    super.new(name);
  endfunction

  task body();

    //req = mem_tx::type_id::create("req");
    req=new(); //randc 
    
    repeat (8) begin
      
      start_item(req);
      tx_1=new req;
      tx_Q.push_back(tx_1);

      assert(req.randomize() with {
        wr_rd_i == 1;
      });

      finish_item(req);

      //$display("FROM SEQUENCE");
      //req.print();

    end
    
    
    //read 
    
   // tb_top.reset_dut();
    
    repeat (8) begin
      
      tx_2=tx_Q.pop_front();
      req=new();
      start_item(req); 
      
      assert(req.randomize() with {
        wr_rd_i == 0;addr_i==tx_2.addr_i;
      });

      finish_item(req);

      //$display("FROM SEQUENCE");
      //req.print();

    end

  endtask

endclass