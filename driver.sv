class driver;

    virtual fifo_if vif;

    function new(virtual fifo_if vif);
        this.vif = vif;
    endfunction

    task reset();
        vif.rst_n = 1;
        @(posedge vif.clk);
        @(posedge vif.clk);
        vif.rst_n = 0;
        @(posedge vif.clk);
        @(posedge vif.clk);
        vif.rst_n = 1;
    endtask

    task enq(int data);
        vif.wr_en = 1;
        vif.data_in = data;
        @(posedge vif.clk);
        vif.wr_en = 0;
    endtask

    task deq();
        int rd_data;

        vif.rd_en = 1;
        @(posedge vif.clk);
        vif.rd_en = 0;
    endtask



endclass