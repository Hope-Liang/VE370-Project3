`timescale 1ns / 1ps

// 2-way associative, write back simulation module
module cache_test_2b();
reg read_writeIn;
wire read_writeOut, hit;
reg [9:0] address;
wire [9:0] addressOut;
reg [7:0] writeDataIn;
wire [127:0] writeDataOut;
wire [127:0] readDataIn;
wire [7:0] readDataOut;
// integer i;   // only used to print all the memory contents

initial 
begin
#100 $finish;
end

mainmem mainmem1(read_writeOut,addressOut,writeDataOut,readDataIn);
cache_2b cache2b(read_writeIn, address, writeDataIn,readDataOut,hit,read_writeOut, addressOut, writeDataOut,readDataIn);
initial 
begin
    #0 read_writeIn = 0; address = 10'b000000000; //should miss
    #1 $display("%b", cache2b.hit);
    #1 $display("0x%h",  cache2b.readDataOut);
	/*$display("Initial memory, shown by 4 words per line");
	for (i=0; i < 64; i=i+1) begin
            $display("0x%h",  mainmem1.mem[i]);
	end*/
    #10 read_writeIn = 1; address = 10'b000000000; writeDataIn = 8'b11111111; //should hit
    #1 $display("%b", cache2b.hit);
    #10 read_writeIn = 0; address = 10'b000000000; //should hit and read out 0xff
    #1 $display("%b", cache2b.hit);
    #1 $display("0x%h",  cache2b.readDataOut);
	// here check main memory content, 
        //the first byte should remain 0x00 if it is write-back, 
	$display("0x%h",  mainmem1.mem[0]);
	/*$display("Complete memory result, shown by 4 words per line");
	for (i=0; i < 64; i=i+1) begin
            $display("0x%h",  mainmem1.mem[i]);
	end*/
    #10 read_writeIn = 0; address = 10'b1000000000; //should miss
    #1 $display("%b", cache2b.hit);
    #1 $display("0x%h",  cache2b.readDataOut);
    // $display("0x%h",  mainmem1.mem[0]);
    #10 read_writeIn = 0; address = 10'b0000000000; //should hit for 2-way associative, should miss for directly mapped
    #1 $display("%b", cache2b.hit);
    #1 $display("0x%h",  cache2b.readDataOut);
    #10 read_writeIn = 0; address = 10'b1100000000; //should miss
    #1 $display("%b", cache2b.hit);
    #1 $display("0x%h",  cache2b.readDataOut);
    #10 read_writeIn = 0; address = 10'b1000000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
    #1 $display("%b", cache2b.hit);
    #1 $display("0x%h",  cache2b.readDataOut);
        //here check main memory content, 
        //the first byte should be 0xff
       $display("0x%h",  mainmem1.mem[0]);
       /*$display("Complete memory result, shown by 4 words per line");
       for (i=0; i < 64; i=i+1) begin
           $display("0x%h",  mainmem1.mem[i]);
       end*/
end
endmodule
