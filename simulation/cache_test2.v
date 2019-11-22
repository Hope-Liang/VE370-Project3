`timescale 1ns / 1ps
// self-written test case 2
module cache_test3();

reg read_writeIn;
wire read_writeOut, hit;
reg [9:0] address;
wire [9:0] addressOut;
reg [7:0] writeDataIn;
wire [127:0] writeDataOut;
wire [127:0] readDataIn;
wire [7:0] readDataOut;

initial 
begin
#135 $finish;
end


mainmem mainmem1(read_writeOut,addressOut,writeDataOut,readDataIn);

/*cache1a cache1_a(read_writeIn, address, writeDataIn,readDataOut,hit,read_writeOut, addressOut, writeDataOut,readDataIn);
initial 
begin
#0 read_writeIn = 1; address = 10'b0100000001; writeDataIn = 8'b11111111; //should miss
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  mainmem1.mem[address[9:4]]);
#10 read_writeIn = 0; address = 10'b0100000001; //should hit and read out 0xff
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

//here check main memory content, 
//the second byte should remain 0x00 if it is write-back, 
//should change to 0xff if it is write-through.
$display("0x%h",  mainmem1.mem[address[9:4]]);

#10 read_writeIn = 0; address = 10'b1000000010; //should miss; writeback for directly mapped
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

#10 read_writeIn = 0; address = 10'b0100000100; //should hit for 2-way associative, should miss for directly mapped
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

#10 read_writeIn = 0; address = 10'b0010001000; //should miss and not writeback, for 2-way associative, block in set 0 should have the tags 01000 and 00100
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

#10 read_writeIn = 0; address = 10'b1100000000; //should miss; for 2-way associative, block in set 0 should have the tags 11000 and 00100
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

#10 read_writeIn = 0; address = 10'b0100000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b11111110; 
//should miss and set dirty, but not writeback; for directly mapped, the third byte of the second word in block with index 01 is written, with the tag 0100; for 2-way asscociative, block 00 in set 1 is written, with the tag 01000
//here check main memory content, 
//mem[6'b010001] should be 0x00000000 0000fe00 00000000 00000000 if write through
#1 $display("%b", cache1_a.hit);
#0.1 
$display("0x%h",  mainmem1.mem[6'b010001]);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b00010001; //should hit and not writeback
//mem[6'b010001] should be 0x00000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache1_a.hit);
#0.1 
$display("0x%h",  mainmem1.mem[6'b010001]);

#10 read_writeIn = 0; address = 10'b0100010000; //should hit and not writeback, readout 0x0
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

#10 read_writeIn = 1; address = 10'b0100010000; writeDataIn = 8'b11111111;//should hit and not writeback
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  mainmem1.mem[6'b010001]);

#10 read_writeIn = 0; address = 10'b1000010000; // should miss, and directly mapped write back
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);
$display("0x%h",  mainmem1.mem[6'b010001]);
$display("0x%h",  mainmem1.mem[6'b100001]);

//here check main memory content, 
//mem[6'b010001] should remain 0x0 if it is 2-way associative writeback, 
//should change to 0xff000000 00001100 00000000 00000000 otherwise

#10 read_writeIn = 0; address = 10'b0100110000; // should miss, and 2-way write back
#1 $display("%b", cache1_a.hit);
#0.1 $display("0x%h",  cache1_a.readDataOut);

//here check main memory content, 
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000
end*/

cache1b cache1_b(read_writeIn, address, writeDataIn,readDataOut,hit,read_writeOut, addressOut, writeDataOut,readDataIn);
initial 
begin
#0 read_writeIn = 1; address = 10'b0100000001; writeDataIn = 8'b11111111; //should miss
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  mainmem1.mem[address[9:4]]);
#10 read_writeIn = 0; address = 10'b0100000001; //should hit and read out 0xff
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

//here check main memory content, 
//the second byte should remain 0x00 if it is write-back, 
//should change to 0xff if it is write-through.
$display("0x%h",  mainmem1.mem[address[9:4]]);

#10 read_writeIn = 0; address = 10'b1000000010; //should miss; writeback for directly mapped
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

#10 read_writeIn = 0; address = 10'b0100000100; //should hit for 2-way associative, should miss for directly mapped
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

#10 read_writeIn = 0; address = 10'b0010001000; //should miss and not writeback, for 2-way associative, block in set 0 should have the tags 01000 and 00100
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

#10 read_writeIn = 0; address = 10'b1100000000; //should miss; for 2-way associative, block in set 0 should have the tags 11000 and 00100
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

#10 read_writeIn = 0; address = 10'b0100000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b11111110; 
//should miss and set dirty, but not writeback; for directly mapped, the third byte of the second word in block with index 01 is written, with the tag 0100; for 2-way asscociative, block 00 in set 1 is written, with the tag 01000
//here check main memory content, 
//mem[6'b010001] should be 0x00000000 0000fe00 00000000 00000000 if write through
#1 $display("%b", cache1_b.hit);
#0.1 
$display("0x%h",  mainmem1.mem[6'b010001]);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b00010001; //should hit and not writeback
//mem[6'b010001] should be 0x00000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache1_b.hit);
#0.1 
$display("0x%h",  mainmem1.mem[6'b010001]);

#10 read_writeIn = 0; address = 10'b0100010000; //should hit and not writeback, readout 0x0
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);

#10 read_writeIn = 1; address = 10'b0100010000; writeDataIn = 8'b11111111;//should hit and not writeback
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  mainmem1.mem[6'b010001]);

#10 read_writeIn = 0; address = 10'b1000010000; // should miss, and directly mapped write back
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);
$display("0x%h",  mainmem1.mem[6'b010001]);
$display("0x%h",  mainmem1.mem[6'b100001]);

//here check main memory content, 
//mem[6'b010001] should remain 0x0 if it is 2-way associative writeback, 
//should change to 0xff000000 00001100 00000000 00000000 otherwise

#10 read_writeIn = 0; address = 10'b0100110000; // should miss, and 2-way write back
#1 $display("%b", cache1_b.hit);
#0.1 $display("0x%h",  cache1_b.readdata);
end

/*cache_2a cache2a(read_writeIn, address, writeDataIn,readDataOut,hit,read_writeOut, addressOut, writeDataOut,readDataIn);
initial 
begin
#0 read_writeIn = 1; address = 10'b0100000001; writeDataIn = 8'b11111111; //should miss
#1 $display("%b", cache2a.hit);
#10 read_writeIn = 0; address = 10'b0100000001; //should hit and read out 0xff
#1 $display("%b", cache2a.hit);
$display("0x%h",  cache2a.readDataOut);

//here check main memory content, 
//the second byte should remain 0x00 if it is write-back, 
//should change to 0xff if it is write-through.
$display("0x%h",  mainmem1.mem[address[9:4]]);

#10 read_writeIn = 0; address = 10'b1000000010; //should miss; writeback for directly mapped
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);
$display("0x%h",  mainmem1.mem[6'b010000]);

#10 read_writeIn = 0; address = 10'b0100000100; //should hit for 2-way associative, should miss for directly mapped
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);

#10 read_writeIn = 0; address = 10'b0010001000; //should miss and not writeback, for 2-way associative, block in set 0 should have the tags 01000 and 00100
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);

#10 read_writeIn = 0; address = 10'b1100000000; //should miss; for 2-way associative, block in set 0 should have the tags 11000 and 00100
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);

#10 read_writeIn = 0; address = 10'b0100000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b11111110; 
//should miss and set dirty, but not writeback; for directly mapped, the third byte of the second word in block with index 01 is written, with the tag 0100; for 2-way asscociative, block 00 in set 1 is written, with the tag 01000
//here check main memory content, 
//mem[6'b010001] should be 0x00000000 0000fe00 00000000 00000000 if write through
#1 $display("%b", cache2a.hit);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b00010001; //should hit and not writeback
//mem[6'b010001] should be 0x00000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache2a.hit);

#10 read_writeIn = 0; address = 10'b0100010000; //should hit and not writeback, readout 0x0
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);

#10 read_writeIn = 1; address = 10'b0100010000; writeDataIn = 8'b11111111;//should hit and not writeback
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache2a.hit);

#10 read_writeIn = 0; address = 10'b1000010000; // should miss, and directly mapped write back
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);
$display("0x%h",  mainmem1.mem[6'b010001]);

//here check main memory content, 
//mem[6'b010001] should remain 0x0 if it is 2-way associative writeback, 
//should change to 0xff000000 00001100 00000000 00000000 otherwise

#10 read_writeIn = 0; address = 10'b0100110000; // should miss, and 2-way write back
#1 $display("%b", cache2a.hit);
#0.1 $display("%h", readDataOut);
$display("0x%h",  mainmem1.mem[6'b010001]);

//here check main memory content, 
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000
end*/

/*cache_2b cache2b(read_writeIn, address, writeDataIn,readDataOut,hit,read_writeOut, addressOut, writeDataOut,readDataIn);
initial 
begin
#0 read_writeIn = 1; address = 10'b0100000001; writeDataIn = 8'b11111111; //should miss
#1 $display("%b", cache2b.hit);
#10 read_writeIn = 0; address = 10'b0100000001; //should hit and read out 0xff
#1 $display("%b", cache2b.hit);
$display("0x%h",  cache2b.readDataOut);

//here check main memory content, 
//the second byte should remain 0x00 if it is write-back, 
//should change to 0xff if it is write-through.
$display("0x%h",  mainmem1.mem[address[9:4]]);

#10 read_writeIn = 0; address = 10'b1000000010; //should miss; writeback for directly mapped
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);
$display("0x%h",  mainmem1.mem[6'b010000]);

#10 read_writeIn = 0; address = 10'b0100000100; //should hit for 2-way associative, should miss for directly mapped
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);

#10 read_writeIn = 0; address = 10'b0010001000; //should miss and not writeback, for 2-way associative, block in set 0 should have the tags 01000 and 00100
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);

#10 read_writeIn = 0; address = 10'b1100000000; //should miss; for 2-way associative, block in set 0 should have the tags 11000 and 00100
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);

#10 read_writeIn = 0; address = 10'b0100000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b11111110; 
//should miss and set dirty, but not writeback; for directly mapped, the third byte of the second word in block with index 01 is written, with the tag 0100; for 2-way asscociative, block 00 in set 1 is written, with the tag 01000
//here check main memory content, 
//mem[6'b010001] should be 0x00000000 0000fe00 00000000 00000000 if write through
#1 $display("%b", cache2b.hit);

#10 read_writeIn = 1; address = 10'b0100010111; writeDataIn = 8'b00010001; //should hit and not writeback
//mem[6'b010001] should be 0x00000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache2b.hit);

#10 read_writeIn = 0; address = 10'b0100010000; //should hit and not writeback, readout 0x0
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);

#10 read_writeIn = 1; address = 10'b0100010000; writeDataIn = 8'b11111111;//should hit and not writeback
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000 if write through
#1 $display("%b", cache2b.hit);

#10 read_writeIn = 0; address = 10'b1000010000; // should miss, and directly mapped write back
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);
$display("0x%h",  mainmem1.mem[6'b010001]);

//here check main memory content, 
//mem[6'b010001] should remain 0x0 if it is 2-way associative writeback, 
//should change to 0xff000000 00001100 00000000 00000000 otherwise

#10 read_writeIn = 0; address = 10'b0100110000; // should miss, and 2-way write back
#1 $display("%b", cache2b.hit);
#0.1 $display("%h", cache2b.readDataOut);
$display("0x%h",  mainmem1.mem[6'b010001]);

//here check main memory content, 
//mem[6'b010001] should be 0xff000000 00001100 00000000 00000000
end*/

endmodule
