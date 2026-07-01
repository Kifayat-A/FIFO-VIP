`include "interface.sv"
`timescale 1ns/1ps

module tb_top;

  localparam WIDTH = 8;
  localparam DEPTH = 16;
  localparam ADDR  = 4;

  bit clk;
  bit rst_n;

  initial clk = 0;
  always #5 clk = ~clk;

  fifo_if #(
      .WIDTH (WIDTH),
      .DEPTH (DEPTH),
      .ADDR  (ADDR)
  ) vif (
      .clk   (clk),
      .rst_n (rst_n)
  );

  fifo_sync #(
      .WIDTH (WIDTH),
      .DEPTH (DEPTH),
      .ADDR  (ADDR)
  ) dut (
      .clk      (clk),
      .rst_n    (rst_n),
      .data_in  (vif.data_in),
      .wr_en    (vif.wr_en),
      .rd_en    (vif.rd_en),
      .data_out (vif.data_out),
      .full     (vif.full),
      .empty    (vif.empty),
      .data_vld (vif.data_vld)
  );

    task reset();
        rst_n = 1;
        @(posedge clk);
        @(posedge clk);
        rst_n = 0;
        @(posedge clk);
        @(posedge clk);
        rst_n = 1;
    endtask

    task enq(int data);
        vif.wr_en = 1;
        vif.data_in = data;
        @(posedge clk);
        vif.wr_en = 0;
    endtask

    task deq();
        int rd_data;

        vif.rd_en = 1;
        @(posedge clk);
        vif.rd_en = 0;
    endtask

    task monitor_output();
    int rd_data;
    forever begin
        @(posedge clk);
        #1;
        if (vif.data_vld) begin
            rd_data = vif.data_out;
            $display("[%0t] READ DATA FROM RTL : %0d", $time, rd_data);
        end
    end
    endtask

  initial begin
        int i;
        int data;

        fork
        monitor_output();   
        join_none
        
        reset();
        
        for(i=0;i<16;i++) begin
            data = $urandom_range(16,0);
            enq(data);
        end

        for(i=0;i<16;i++) begin
            deq();
        end

        #200;
        $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end


endmodule