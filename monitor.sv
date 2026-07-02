class monitor;
    virtual fifo_if vif;
    function new(virtual fifo_if vif);
        this.vif = vif;
    endfunction

    task monitor_output();
        int rd_data;
        forever begin
            @(posedge vif.clk);
            #1;
            if (vif.data_vld) begin
                rd_data = vif.data_out;
                $display("[%0t] READ DATA FROM RTL : %0d", $time, rd_data);
            end
        end
    endtask 
endclass