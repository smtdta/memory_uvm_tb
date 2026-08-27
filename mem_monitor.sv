class mem_monitor extends uvm_monitor;

  `uvm_component_utils(mem_monitor)

  virtual mem_interface #(`WIDTH, `DEPTH) mon_vif;

  uvm_analysis_port #(mem_tx) ap_port;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);

    //mon_vif = mem_common::vif;
    uvm_resource_db#(virtual mem_interface#(`WIDTH,`DEPTH))::read_by_name("*", "vif", mon_vif, this);
    ap_port = new("ap_port", this);
  endfunction

  task run_phase(uvm_phase phase);

    forever begin

      @(mon_vif.mon_cb);

      if (mon_vif.mon_cb.valid_intf &&
          mon_vif.mon_cb.ready_intf) begin

        mem_tx tx;

        tx = mem_tx::type_id::create("tx");

        tx.addr_i  = mon_vif.mon_cb.addr_intf;
        tx.wdata_i = mon_vif.mon_cb.wdata_intf;
        tx.wr_rd_i = mon_vif.mon_cb.wr_rd_intf;
        tx.rdata_o = mon_vif.mon_cb.rdata_intf;

        //tx.print();//"MONITOR after sampling the tx fields");

        // Broadcast to coverage
        ap_port.write(tx);

      end

    end

  endtask

endclass