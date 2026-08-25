class mem_driver extends uvm_driver #(mem_tx);
  
   virtual mem_interface #(`WIDTH, `DEPTH) drv_vif;
  
  //factory reg 
  
  `uvm_component_utils(mem_driver)
  
  //constructor 
  
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    drv_vif=mem_common::vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      
      $display("DRIVER GOT THIS FROM SQR");
      
      req.print();
      
      //drive the tx through intf
      
      drive_tx(req);
      
      seq_item_port.item_done();  
      
    end
    
  endtask
  
  //without using cb for driver interface 
  
 task drive_tx(mem_tx tx);

  @(posedge drv_vif.clk_intf);

  drv_vif.addr_intf  = tx.addr_i;
  drv_vif.wdata_intf = tx.wdata_i;
  drv_vif.wr_rd_intf = tx.wr_rd_i;
  
  @(posedge drv_vif.clk_intf);
  drv_vif.valid_intf = 1'b1;

  wait (drv_vif.ready_intf == 1'b1);

  @(posedge drv_vif.clk_intf);

  drv_vif.valid_intf = 1'b0;
  
  //wait (drv_vif.ready_intf == 1'b0);
   
endtask 
  
  
  //withusing cb for driver interface 
  
 /* task drive_tx(mem_tx tx);

  @(drv_vif.drv_cb);

  drv_vif.drv_cb.addr_intf  <= tx.addr_i;
  drv_vif.drv_cb.wdata_intf <= tx.wdata_i;
  drv_vif.drv_cb.wr_rd_intf <= tx.wr_rd_i;

  drv_vif.drv_cb.valid_intf <= 1'b1;

  wait (drv_vif.drv_cb.ready_intf == 1'b1);

  @(drv_vif.drv_cb);

  drv_vif.drv_cb.valid_intf <= 1'b0;
  drv_vif.drv_cb.addr_intf  <= '0;
  drv_vif.drv_cb.wr_rd_intf <= 1'b0;
  drv_vif.drv_cb.wdata_intf <= '0;

  endtask */
  
   
endclass
