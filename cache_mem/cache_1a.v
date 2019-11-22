`timescale 1ns / 1ps

// direct mapped, write through cache module
module cache1a(read_write,address,writedata,readDataOut,hit,memread_write,memaddr,memwrite,memread);
input read_write;// 0 for read, 1 for write
input [9:0] address;
output reg [9:0] memaddr;
input [7:0] writedata;
output reg [127:0] memwrite;
output reg hit,memread_write;
output reg [7:0] readDataOut;
input [127:0]memread;
integer i;
// blocks
reg [31:0]cache[15:0];
// tag fields
reg [3:0]tag[3:0];
// valid field
reg [0:0]V[3:0];
initial begin
memread_write=0;
for(i=0;i<4;i=i+1) begin
V[i]=0;
tag[i]=4'b0;
end
for(i=0;i<16;i=i+1) begin
cache[i]=16'b0;
end
end

always @(read_write,address,writedata) begin
memaddr = address;
// read
if(read_write==0) begin
   memread_write=0;
   if(V[address[5:4]]==1&&tag[address[5:4]]==address[9:6]) begin
      hit=1;
      case(address[1:0])
        2'b00:readDataOut=cache[address[5:2]][31:24];
        2'b01:readDataOut=cache[address[5:2]][23:16];
        2'b10:readDataOut=cache[address[5:2]][15:8];
        2'b11:readDataOut=cache[address[5:2]][7:0];
      endcase
   end
   else begin
      hit=0;
      #0.1
      cache[address[5:4]*4]=memread[127:96];
      cache[address[5:4]*4+1]=memread[95:64];
      cache[address[5:4]*4+2]=memread[63:32];
      cache[address[5:4]*4+3]=memread[31:0];
      tag[address[5:4]]=address[9:6];
      V[address[5:4]]=1'b1;
      #0.1
      case(address[1:0])
        2'b00:readDataOut=cache[address[5:2]][31:24];
        2'b01:readDataOut=cache[address[5:2]][23:16];
        2'b10:readDataOut=cache[address[5:2]][15:8];
        2'b11:readDataOut=cache[address[5:2]][7:0];
      endcase      
   end
end
// write
else begin
   if(V[address[5:4]]==1&&tag[address[5:4]]==address[9:6]) begin
      hit=1;
      case(address[1:0])
          2'b00:cache[address[5:2]][31:24]=writedata;
          2'b01:cache[address[5:2]][23:16]=writedata;
          2'b10:cache[address[5:2]][15:8]=writedata;
          2'b11:cache[address[5:2]][7:0]=writedata;
      endcase     
   end
   else begin
      hit=0;
      if (!V[address[5:4]])
        tag[address[5:4]] = address[9:6];
      memaddr = {tag[address[5:4]],address[5:4],{4{1'b0}}}; 
      #0.1 
      cache[address[5:4]*4]=memread[127:96];
      cache[address[5:4]*4+1]=memread[95:64];
      cache[address[5:4]*4+2]=memread[63:32];
      cache[address[5:4]*4+3]=memread[31:0];
      case(address[1:0])
          2'b11: cache[address[5:2]][7:0]=writedata;
          2'b10: cache[address[5:2]][15:8]=writedata;
          2'b01: cache[address[5:2]][23:16]=writedata;
          2'b00: cache[address[5:2]][31:24]=writedata;        
      endcase    
   end 
   memread_write=1;
   memwrite[127:96]=cache[address[5:4]*4];
   memwrite[95:64]=cache[address[5:4]*4+1];
   memwrite[63:32]=cache[address[5:4]*4+2];
   memwrite[31:0]=cache[address[5:4]*4+3];
   tag[address[5:4]]=address[9:6];
   V[address[5:4]]=1;
end
end   

endmodule