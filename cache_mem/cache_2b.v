`timescale 1ns / 1ps

// 2-way associative, write back cache module
module cache_2b(
    read_writeIn,
    address,
    writeDataIn,
    readDataOut,
    hit,
    read_writeOut, 
    addressOut,
    writeDataOut,
    readDataIn   
    );
    input read_writeIn; // 0 for read, 1 for write
    output reg read_writeOut; 
    // 9-5: tag field, 4: set index (4 blocks/cache = 2 sets/cache), 3-2, word offset, 1-0: byte offset
    input [9:0] address;
    output reg [9:0] addressOut;
    input [7:0] writeDataIn;
    output reg [127:0] writeDataOut;
    input [127:0] readDataIn;
    output reg [7:0] readDataOut;
    output reg hit;
    /* 4 blocks in a cache, 0-1 for set 0, 2-3 for set 1, 
     * in each block: 4*32+5+1+1 = 135 bits, 134: valid field, 133: dirty field, 132-128: tag, 
     * 127-96: word0 (127-120: byte0, 119-112: byte1, 111-104: byte2, 103-96: byte3),
     * 95-64: word1 (95-88: byte0, 87-80: byte1, 79-72: byte2, 71-64: byte3), 
     * 63-32: word2 (63-56: byte0, 55-48: byte1, 47-40: byte3, 39-32: byte3),
     * 31-0: word3 (31-24: byte0, 23-16: byte1, 15-8: byte2, 7-0: byte3) */
    reg [134:0] block [0:3];
    reg LRU [0:1];  
    // keep track of least-recently used in 2 sets, LRU[0] for set0, LRU[1] for set 1, 0 for LRU 1st block, 1 for LRU 2nd block
    reg [1:0] blockIndex;
    
    integer i;
    initial begin
        hit = 1'b0;
        read_writeOut = 1'b0;
        for (i = 0; i < 4; i = i+1) 
            block[i][134:128] = 0;
        LRU[0] = 1'b0;
        LRU[1] = 1'b0;
        blockIndex = 0;
   end
   
    always@(read_writeIn, address, writeDataIn)begin
        hit = 1'b0;
        addressOut = address;
        // set0
       if (!address[4]) begin
           if (block[0][134] && (block[0][132:128] == address[9:5])) begin
               hit = 1'b1;
               blockIndex = 0;
               LRU[0] = 1'b1;
           end
           else if (block[1][134] && (block[1][132:128] == address[9:5])) begin
               hit = 1'b1;
               blockIndex = 1;
               LRU[0] = 1'b0;
           end
       end
       // set1
       else begin
           if (block[2][134] && (block[2][132:128] == address[9:5])) begin
               hit = 1'b1;
               blockIndex = 2;
               LRU[1] = 1'b1;
           end
           else if (block[3][134] && (block[3][132:128] == address[9:5])) begin
               hit = 1'b1;
               blockIndex = 3;
               LRU[1] = 1'b0;
           end
       end
       // locate block if miss
       if (!hit) begin
           // set0
           if  (!address[4]) begin
               if (!block[0][134]) begin
                   blockIndex = 0;
                   LRU[0] = 1'b1;
               end
               else if (!block[1][134]) begin
                   blockIndex = 1;
                   LRU[0] = 1'b0;
               end
               else begin 
                   if (!LRU[0])
                       blockIndex = 0;
                   else
                       blockIndex = 1;
                   LRU[0] = ~LRU[0];
               end
           end
           // set1
           else begin
               if (!block[2][134]) begin
                   blockIndex = 2;
                   LRU[1] = 1'b1;
               end
               else if (!block[3][134]) begin
                   blockIndex = 3;
                   LRU[1] = 1'b0;
               end
               else begin 
                   if (!LRU[1])
                       blockIndex = 2;
                   else
                       blockIndex = 3;
                   LRU[1] = ~LRU[1];
               end
           end
       end
       // write
       if (read_writeIn) begin
           if (!hit) begin
               if (block[blockIndex][133]) begin  
                   // dirty, write previous data back to main memory
                   read_writeOut = 1'b1;
                   writeDataOut = block[blockIndex][127:0];
                   addressOut = {block[blockIndex][132:128],address[4],{4{1'b0}}};
               end
               #1 read_writeOut = 1'b0;
               addressOut = address;
               block[blockIndex][132:128] = address[9:5];   // set tag field
               block[blockIndex][127:0] = readDataIn; // read data from main memory
           end
            // write the new data into the cache block, byte addressable
           case(address[3:0]) 
               4'b0000: block[blockIndex][127:120] = writeDataIn;
               4'b0001: block[blockIndex][119:112] = writeDataIn;
               4'b0010: block[blockIndex][111:104] = writeDataIn;
               4'b0011: block[blockIndex][103:96] = writeDataIn;
               4'b0100: block[blockIndex][95:88] = writeDataIn;
               4'b0101: block[blockIndex][87:80] = writeDataIn;
               4'b0110: block[blockIndex][79:72] = writeDataIn;
               4'b0111: block[blockIndex][71:64] = writeDataIn;
               4'b1000: block[blockIndex][63:56] = writeDataIn;
               4'b1001: block[blockIndex][55:48] = writeDataIn;
               4'b1010: block[blockIndex][47:40] = writeDataIn;
               4'b1011: block[blockIndex][39:32] = writeDataIn;
               4'b1100: block[blockIndex][31:24] = writeDataIn;
               4'b1101: block[blockIndex][23:16] = writeDataIn;
               4'b1110: block[blockIndex][15:8] = writeDataIn;
               4'b1111: block[blockIndex][7:0] = writeDataIn;
           endcase
           block[blockIndex][134:133] = 2'b11;   // mark the cache block as dirty
       end
       // read
       else begin
           if(!hit) begin
               if (block[blockIndex][133]) begin  
                   // dirty, write previous data back to main memory
                   read_writeOut = 1'b1;
                   writeDataOut = block[blockIndex][127:0];
                   addressOut = {block[blockIndex][132:128],address[4],{4{1'b0}}};
               end
               #1 read_writeOut = 1'b0;
               addressOut = address;
               block[blockIndex][132:128] = address[9:5];   // set tag field
               block[blockIndex][127:0] = readDataIn;  // read data from main memory
               block[blockIndex][134:133] = 2'b10;   // mark the cache block as not dirty
           end
           // return data
            case(address[3:0]) 
               4'b0000: readDataOut = block[blockIndex][127:120];
               4'b0001: readDataOut = block[blockIndex][119:112];
               4'b0010: readDataOut = block[blockIndex][111:104];
               4'b0011: readDataOut = block[blockIndex][103:96];
               4'b0100: readDataOut = block[blockIndex][95:88];
               4'b0101: readDataOut = block[blockIndex][87:80];
               4'b0110: readDataOut = block[blockIndex][79:72];
               4'b0111: readDataOut = block[blockIndex][71:64];
               4'b1000: readDataOut = block[blockIndex][63:56];
               4'b1001: readDataOut = block[blockIndex][55:48];
               4'b1010: readDataOut = block[blockIndex][47:40];
               4'b1011: readDataOut = block[blockIndex][39:32];
               4'b1100: readDataOut = block[blockIndex][31:24];
               4'b1101: readDataOut = block[blockIndex][23:16];
               4'b1110: readDataOut = block[blockIndex][15:8];
               4'b1111: readDataOut = block[blockIndex][7:0];
           endcase
       end
   end
   
endmodule
