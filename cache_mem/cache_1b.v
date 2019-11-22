`timescale 1ns / 1ps

// 2-way associative, write through cache module
module cache1b(read_write,address,writedata,readdata,hit,memread_write,memaddr,memwrite,memread);
input read_write;// 0 for read, 1 for write
input [9:0] address;
output reg [9:0]memaddr;
input [7:0] writedata;
output reg [127:0] memwrite;
output reg hit,memread_write;
output reg [7:0] readdata;
input [127:0]memread;
integer i;
reg [31:0]cache[0:15];
reg [4:0]tag[0:3]; // tag field
reg [0:0]V[0:3];   // valid field
reg [0:0]used[0:1];// 0 for first block resently used, 1 for second block
initial begin
hit = 1'b0;
memread_write=0;
for(i=0;i<4;i=i+1) begin
V[i]=0;
tag[i]=0;
end
used[0]=0;
used[1]=0;
end

always @(read_write,address,writedata) begin
memaddr = address;
// read
if(read_write==0) begin
   if(V[address[4]*2]==1&&tag[address[4]*2]==address[9:5]) begin
      hit=1;
      case(address[1:0])
      2'b00: readdata=cache[address[4]*8+address[3:2]][31:24]; 
      2'b01: readdata=cache[address[4]*8+address[3:2]][23:16]; 
      2'b10: readdata=cache[address[4]*8+address[3:2]][15:8];
      2'b11: readdata=cache[address[4]*8+address[3:2]][7:0];  
      endcase 
      used[address[4]]=0;
   end
   else if(V[address[4]*2+1]==1&&tag[address[4]*2+1]==address[9:5]) begin
      hit=1;
      case(address[1:0])
       2'b00: readdata=cache[address[4]*8+4+address[3:2]][31:24]; 
       2'b01: readdata=cache[address[4]*8+4+address[3:2]][23:16]; 
       2'b10: readdata=cache[address[4]*8+4+address[3:2]][15:8];
       2'b11: readdata=cache[address[4]*8+4+address[3:2]][7:0];  
      endcase 
      used[address[4]]=1;
   end
   else begin
      hit=0;   
      if(V[address[4]*2]==0||(V[address[4]*2+1]==1&&used[address[4]]==1)) begin
         used[address[4]]=0;
         #0.1 {cache[address[4]*8],cache[address[4]*8+1],cache[address[4]*8+2],cache[address[4]*8+3]} = memread;
         tag[address[4]*2]=address[9:5];
         V[address[4]*2]=1;
         case(address[1:0])
         2'b00: readdata=cache[address[4]*8+address[3:2]][31:24]; 
         2'b01: readdata=cache[address[4]*8+address[3:2]][23:16]; 
         2'b10: readdata=cache[address[4]*8+address[3:2]][15:8];
         2'b11: readdata=cache[address[4]*8+address[3:2]][7:0];  
        endcase   
      end  
      else begin
         used[address[4]]=1;
         #0.1 {cache[address[4]*8+4],cache[address[4]*8+5],cache[address[4]*8+6],cache[address[4]*8+7]} = memread;
         tag[address[4]*2+1]=address[9:5];
         V[address[4]*2+1]=1;
         case(address[1:0])
         2'b00: readdata=cache[address[4]*8+4+address[3:2]][31:24]; 
         2'b01: readdata=cache[address[4]*8+4+address[3:2]][23:16]; 
         2'b10: readdata=cache[address[4]*8+4+address[3:2]][15:8];
         2'b11: readdata=cache[address[4]*8+4+address[3:2]][7:0];  
         endcase 
      end
   end
end
// write
else begin
   if(V[address[4]*2]==1&&tag[address[4]*2]==address[9:5]) begin
      hit=1;
      case(address[1:0])
          2'b00: cache[address[4]*8+address[3:2]][31:24]=writedata;
          2'b01: cache[address[4]*8+address[3:2]][23:16]=writedata;
          2'b10: cache[address[4]*8+address[3:2]][15:8]=writedata;
          2'b11: cache[address[4]*8+address[3:2]][7:0]=writedata; 
      endcase  
      memread_write=1;
      memwrite={cache[address[4]*8],cache[address[4]*8+1],cache[address[4]*8+2],cache[address[4]*8+3]};
      #1
      used[address[4]]=0;
      memread_write=0;
   end
   else if(V[address[4]*2+1]==1&&tag[address[4]*2+1]==address[9:5]) begin
      hit=1;
       case(address[1:0])
               2'b00: cache[address[4]*8+4+address[3:2]][31:24]=writedata;
               2'b01: cache[address[4]*8+4+address[3:2]][23:16]=writedata;
               2'b10: cache[address[4]*8+4+address[3:2]][15:8]=writedata;
               2'b11: cache[address[4]*8+4+address[3:2]][7:0]=writedata; 
      endcase  
      memread_write=1;
      memwrite={cache[address[4]*8+4],cache[address[4]*8+5],cache[address[4]*8+6],cache[address[4]*8+7]};
      #1
      used[address[4]]=1;
      memread_write=0;
   end
   else begin
      hit=0;   
      if(V[address[4]*2]==0||(V[address[4]*2+1]==1&&used[address[4]]==1)) begin
         #0.1 {cache[address[4]*8],cache[address[4]*8+1],cache[address[4]*8+2],cache[address[4]*8+3]} = memread;
         if (!V[address[4]*2])
            tag[address[4]*2] = address[9:5];
         V[address[4]*2]=1;
         case(address[1:0])
                  2'b00: cache[address[4]*8+address[3:2]][31:24]=writedata;
                  2'b01: cache[address[4]*8+address[3:2]][23:16]=writedata;
                  2'b10: cache[address[4]*8+address[3:2]][15:8]=writedata;
                  2'b11: cache[address[4]*8+address[3:2]][7:0]=writedata; 
         endcase       
         memread_write=1;
         memaddr = {tag[address[4]*2],address[4],{4{1'b0}}};
         memwrite={cache[address[4]*8],cache[address[4]*8+1],cache[address[4]*8+2],cache[address[4]*8+3]};
         #1
         memread_write=0;
         memaddr = address; 
         tag[address[4]*2]=address[9:5];
      end  
      else begin
         #0.1 {cache[address[4]*8+4],cache[address[4]*8+5],cache[address[4]*8+6],cache[address[4]*8+7]} = memread;
         if (!V[address[4]*2+1])
             tag[address[4]*2+1] = address[9:5];
         V[address[4]*2+1]=1; 
          case(address[1:0])
                  2'b00: cache[address[4]*8+4+address[3:2]][31:24]=writedata;
                  2'b01: cache[address[4]*8+4+address[3:2]][23:16]=writedata;
                  2'b10: cache[address[4]*8+4+address[3:2]][15:8]=writedata;
                  2'b11: cache[address[4]*8+4+address[3:2]][7:0]=writedata; 
         endcase          
         memread_write=1;
         memaddr = {tag[address[4]*2+1],address[4],{4{1'b0}}};
         memwrite={cache[address[4]*8+4],cache[address[4]*8+5],cache[address[4]*8+6],cache[address[4]*8+7]};
         #1
         memread_write=0;
         memaddr = address;
         tag[address[4]*2+1]=address[9:5];
      end
   end
end

end   
endmodule