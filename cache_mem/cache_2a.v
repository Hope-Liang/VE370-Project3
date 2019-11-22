`timescale 1ns / 1ps

// direct mapped, write back cache module
module cache_2a(  
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
    // 9-6: tag field, 5-4: cache index (64 bytes/cache = 16 words/cache = 4 blocks/cache), 3-2, word offset, 1-0: byte offset
    input [9:0] address;
    output reg [9:0] addressOut;
    // for simplicty in project 3 since the tests are only performed on bytes
    input [7:0] writeDataIn;
    output reg [127:0] writeDataOut;
    input [127:0] readDataIn;
    // for simplicty in project 3 since the tests are only performed on bytes
    output reg [7:0] readDataOut;   
    output reg hit; // 0 for miss, 1 for hit
    /* 4 blocks in a cache, and in each block: 4*32+4+1+1 = 134 bits
     * 133: valid field, 132: dirty field, 131-128: tag, 
     * 127-96: word0 (127-120: byte0, 119-112: byte1, 111-104: byte2, 103-96: byte3),
     * 95-64: word1 (95-88: byte0, 87-80: byte1, 79-72: byte2, 71-64: byte3), 
     * 63-32: word2 (63-56: byte0, 55-48: byte1, 47-40: byte3, 39-32: byte3),
     * 31-0: word3 (31-24: byte0, 23-16: byte1, 15-8: byte2, 7-0: byte3) */
    reg [133:0] block [0:3];
    
    integer i;
    initial begin
        hit = 1'b0;
        read_writeOut = 1'b0;
        for (i = 0; i < 4; i = i+1) 
            block[i][133:128] = 0;
    end
    
    always@(read_writeIn, address, writeDataIn)begin
        hit = block[address[5:4]][133] && (address[9:6] == block[address[5:4]][131:128]);
        addressOut = address;
        // write
        if (read_writeIn) begin
            if (!hit) begin
                if (block[address[5:4]][132]) begin  
                    // dirty, write previous data back to main memory
                    read_writeOut = 1'b1;
                    writeDataOut = block[address[5:4]][127:0];
                    addressOut = {block[address[5:4]][131:128],address[5:4],{4{1'b0}}};
                end
                #1 read_writeOut = 1'b0;
                addressOut = address;
                block[address[5:4]][131:128] = address[9:6];   // set tag field
                block[address[5:4]][127:0] = readDataIn; // read data from main memory
            end
            // write the new data into the cache block, byte addressable
            case(address[3:0]) 
                4'b0000: block[address[5:4]][127:120] = writeDataIn;
                4'b0001: block[address[5:4]][119:112] = writeDataIn;
                4'b0010: block[address[5:4]][111:104] = writeDataIn;
                4'b0011: block[address[5:4]][103:96] = writeDataIn;
                4'b0100: block[address[5:4]][95:88] = writeDataIn;
                4'b0101: block[address[5:4]][87:80] = writeDataIn;
                4'b0110: block[address[5:4]][79:72] = writeDataIn;
                4'b0111: block[address[5:4]][71:64] = writeDataIn;
                4'b1000: block[address[5:4]][63:56] = writeDataIn;
                4'b1001: block[address[5:4]][55:48] = writeDataIn;
                4'b1010: block[address[5:4]][47:40] = writeDataIn;
                4'b1011: block[address[5:4]][39:32] = writeDataIn;
                4'b1100: block[address[5:4]][31:24] = writeDataIn;
                4'b1101: block[address[5:4]][23:16] = writeDataIn;
                4'b1110: block[address[5:4]][15:8] = writeDataIn;
                4'b1111: block[address[5:4]][7:0] = writeDataIn;
            endcase
            block[address[5:4]][133:132] = 2'b11;   // mark the cache block as dirty
        end
        // read
        else begin
            if(!hit) begin
                if (block[address[5:4]][132]) begin  
                    // dirty, write previous data back to main memory
                    read_writeOut = 1'b1;
                    writeDataOut = block[address[5:4]][127:0];
                    addressOut = {block[address[5:4]][131:128],address[5:4],{4{1'b0}}};
                end
                #1 read_writeOut = 1'b0;
                addressOut = address;
                block[address[5:4]][131:128] = address[9:6];   // set tag field
                block[address[5:4]][127:0] = readDataIn;  // read data from main memory
                block[address[5:4]][133:132] = 2'b10;   // mark the cache block as not dirty
            end
            // return data
            case(address[3:0]) 
                4'b0000: readDataOut = block[address[5:4]][127:120];
                4'b0001: readDataOut = block[address[5:4]][119:112];
                4'b0010: readDataOut = block[address[5:4]][111:104];
                4'b0011: readDataOut = block[address[5:4]][103:96];
                4'b0100: readDataOut = block[address[5:4]][95:88];
                4'b0101: readDataOut = block[address[5:4]][87:80];
                4'b0110: readDataOut = block[address[5:4]][79:72];
                4'b0111: readDataOut = block[address[5:4]][71:64];
                4'b1000: readDataOut = block[address[5:4]][63:56];
                4'b1001: readDataOut = block[address[5:4]][55:48];
                4'b1010: readDataOut = block[address[5:4]][47:40];
                4'b1011: readDataOut = block[address[5:4]][39:32];
                4'b1100: readDataOut = block[address[5:4]][31:24];
                4'b1101: readDataOut = block[address[5:4]][23:16];
                4'b1110: readDataOut = block[address[5:4]][15:8];
                4'b1111: readDataOut = block[address[5:4]][7:0];
            endcase
        end
    end
    
endmodule
