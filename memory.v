module memory
(
    clk_i,
    rst_i,
    wr_rd_i,
    rdata_o,
    wdata_i,
    ready_o,
    valid_i,
    addr_i
);

parameter WIDTH = 16;
parameter DEPTH = 8;
  
localparam ADDR_WIDTH = $clog2(DEPTH);

input clk_i;
input rst_i;
input wr_rd_i;
input [WIDTH-1:0] wdata_i;
input valid_i;
input [ADDR_WIDTH-1:0] addr_i;

output reg ready_o;
output reg [WIDTH-1:0] rdata_o;


reg [WIDTH-1:0] mem [DEPTH-1:0];
  
integer i;

always @(posedge clk_i)
begin

    if (rst_i)
    begin
      for ( i = 0; i < DEPTH; i++)
        begin
          mem[i] = '0;
        end

        ready_o = 0;
        rdata_o = '0;
    end

    else if (valid_i)
    begin
        ready_o = 1;

        if (wr_rd_i == 1)
        begin
            mem[addr_i] = wdata_i;
        end

        else
        begin
            rdata_o = mem[addr_i];
        end
    end

    else
    begin
        ready_o = 0;
    end

end

endmodule