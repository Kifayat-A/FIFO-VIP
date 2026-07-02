class transaction;

    rand bit [7:0] data_in;
    rand bit wr_en;
    rand bit rd_en;
    
    bit [7:0] data_out;
    bit       full;
    bit       empty;
    bit       data_vld;

    constraint wr_rd{!(wr_en && rd_en);}
    constraint data_inp{data_in inside {[0:255]};}

    function void print();
        $display("[t] data_in=%0d wr_en=%0b rd_en=%0b | data_out=%0d full=%0b empty=%0b data_vld=%0b",
                   data_in, wr_en, rd_en, data_out, full, empty, data_vld);
    endfunction



endclass