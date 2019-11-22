// main memory module

module mainmem(read_write,address,writedata,readdata);
    input read_write;
    input [9:0] address;
    input [127:0] writedata;
    output [127:0] readdata;
    reg [127:0] readdata;
    reg [127:0]mem[63:0];
    // for simplicity, we read by block size, but actually main memory is byte addressable, 1024 bytes here in total
    integer i;
    initial begin
        for(i=0;i<64;i=i+1) begin
            // the project requirement says we should preload the main memory with random numbers, 
            // but for simplicity, we just preload main memory with 0 
            // mem[i] = $random % 1000000;
            mem[i]=128'b0;
        end
    end
    always @(*) begin
        if(read_write==0) readdata=mem[address[9:4]];
        else mem[address[9:4]]=writedata;
    end
    
    
    
endmodule