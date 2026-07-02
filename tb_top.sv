`include "interface.sv"
`include "driver.sv"
`include "monitor.sv"
`timescale 1ns/1ps

module tb_top;

    localparam WIDTH = 8;
    localparam DEPTH = 16;
    localparam ADDR  = 4;


    fifo_if #(.WIDTH (WIDTH),.DEPTH (DEPTH),.ADDR  (ADDR)) vif();

    fifo_sync #(.WIDTH (WIDTH),.DEPTH (DEPTH),.ADDR  (ADDR)) dut (
      .clk      (vif.clk),
      .rst_n    (vif.rst_n),
      .data_in  (vif.data_in),
      .wr_en    (vif.wr_en),
      .rd_en    (vif.rd_en),
      .data_out (vif.data_out),
      .full     (vif.full),
      .empty    (vif.empty),
      .data_vld (vif.data_vld)
    );

    driver drv;
    monitor mon;

    initial vif.clk = 0;
    always #5 vif.clk = ~vif.clk;

    initial begin
        int i;
        int data;
        drv = new(vif);
        mon = new(vif);

        fork
        mon.monitor_output();   
        join_none
        
        drv.reset();
        
        for(i=0;i<16;i++) begin
            data = $urandom_range(16,0);
            drv.enq(data);
        end

        for(i=0;i<16;i++) begin
            drv.deq();
        end

        #200;
        $finish;
    end

    initial begin
      $dumpfile("dump.fst");
      $dumpvars(0, tb_top);
    end


endmodule