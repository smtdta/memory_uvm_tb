interface mem_interface #(
    parameter WIDTH = 16,
    parameter DEPTH = 8
)(
    clk_intf,
    rst_intf
);

  localparam ADDR_WIDTH = $clog2(DEPTH);

  input clk_intf;
  input rst_intf;
  
  logic [ADDR_WIDTH-1:0] addr_intf;
  logic                  valid_intf;
  logic                  ready_intf;

  logic [WIDTH-1:0]       wdata_intf;
  logic [WIDTH-1:0]       rdata_intf;

  logic                   wr_rd_intf;


  /*
  // Driver clocking block
  clocking drv_cb @(posedge clk_intf);

   // default input #1step output #1step;

    output valid_intf;
    output addr_intf;
    output wdata_intf;
    output wr_rd_intf;

    input ready_intf;
    input rdata_intf;

  endclocking */


  // Monitor clocking block
  clocking mon_cb @(posedge clk_intf);

    default input #0; //keep input #0

    input valid_intf;
    input ready_intf;
    input addr_intf;
    input wdata_intf;
    input wr_rd_intf;
    input rdata_intf;

  endclocking

endinterface