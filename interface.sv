interface fifo_if #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR  = 4
);
    logic             clk;
    logic             rst_n;
    logic [WIDTH-1:0] data_in;
    logic              wr_en;
    logic              rd_en;
    logic [WIDTH-1:0] data_out;
    logic              full;
    logic              empty;
    logic              data_vld;

    clocking drv_cb @(posedge clk);
        default input #1step output #1step;
        output data_in, wr_en, rd_en;
        input  data_out, full, empty ,data_vld;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input data_in, wr_en, rd_en, data_out, full, empty, data_vld;
    endclocking

    modport DRV (clocking drv_cb,  clk, rst_n);
    modport MON (clocking mon_cb,  clk, rst_n);

endinterface