module fifo_sync #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR = 4
)(
    input clk,rst_n,
    input [WIDTH-1:0]data_in,
    input wr_en,
    input rd_en,

    output reg [WIDTH-1:0]data_out,
    output full,empty,
    output reg data_vld
);

reg [WIDTH-1:0] mem [DEPTH-1:0];
reg [ADDR:0] rd_ptr,wr_ptr;


always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_ptr <= 0 ;
    end
    else begin
        if(wr_en && !full) begin
            mem[wr_ptr[ADDR-1:0]] <= data_in;
            wr_ptr <= wr_ptr+1;
        end
    end
end 


always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rd_ptr <= 0 ;
    end
    else begin
        if(rd_en && !empty) begin
            rd_ptr <= rd_ptr+1;
        end
    end
end


assign full  = (wr_ptr[ADDR] != rd_ptr[ADDR]) && 
               (wr_ptr[ADDR-1:0] == rd_ptr[ADDR-1:0]);

assign empty = (wr_ptr==rd_ptr);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
        data_vld <= 0;
    end
    else if (rd_en && !empty) begin
        data_out <= mem[rd_ptr[ADDR-1:0]]; 
        data_vld <= 1;
    end
    else begin
        data_vld <= 0;
        data_out <= 0;
    end
end

//assign data_out = mem[rd_ptr[ADDR-1:0]];

endmodule
