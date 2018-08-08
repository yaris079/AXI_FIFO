`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/02 14:01:01
// Design Name: 
// Module Name: signal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module signal(
    clk,
    rst,
    control,
    length,
    S_AXIS_tready,
    S_AXIS_tdata,
    S_AXIS_tkeep,
    S_AXIS_tlast,
    S_AXIS_tvalid
);
    input clk;
    input rst;
    input control;
    input [31:0]length;
    input S_AXIS_tready;
    output [31:0]S_AXIS_tdata;
    output [3:0]S_AXIS_tkeep;
    output S_AXIS_tlast;
    output S_AXIS_tvalid;
    wire control;
    wire [31:0]length;
    reg [31:0]S_AXIS_tdata;
    reg S_AXIS_tlast;
    reg S_AXIS_tvalid;    
    reg [1:0]state;
    reg [31:0]tmpLength;//用于锁存生成数据的长度
    reg [31:0]cnt;
    
    assign S_AXIS_tkeep = 4'b1111;
    
    always@(posedge clk)
    begin
        if(!rst) begin
         S_AXIS_tvalid <= 1'b0;
         S_AXIS_tdata <= 32'd0;
         S_AXIS_tlast <= 1'b0;
         tmpLength <= 32'd0;
         cnt <= 0;
         state <= 0;
        end
        else begin
            case(state)
              0: begin
                  if(control && S_AXIS_tready) begin
                     S_AXIS_tvalid <= 1'b1;
                     tmpLength <= length;//在state=1开始那个周期tmpLength更新为length
                     S_AXIS_tdata <= length;//数据从tmpLength开始
                     state <= 1;
                  end
                  else begin
                     S_AXIS_tvalid <= 1'b0;
                     state <= 0;
                  end
                end
              1:begin
                   if(S_AXIS_tready) begin
                       S_AXIS_tdata <= S_AXIS_tdata + 1'b1;
                       cnt <= cnt + 1'b1;
                       if(cnt == tmpLength - 2) begin
                          S_AXIS_tlast <= 1'b1;
                          state <= 2;
                       end
                       else begin
                          S_AXIS_tlast <= 1'b0;
                          state <= 1;
                       end
                   end
                   else begin
                      S_AXIS_tdata <= S_AXIS_tdata;                   
                      state <= 1;
                   end
                end       
              2:begin                   
                   if(!S_AXIS_tready) begin
                      S_AXIS_tvalid <= 1'b1;
                      S_AXIS_tlast <= 1'b1;
                      S_AXIS_tdata <= S_AXIS_tdata;
                      state <= 2;
                   end
                   else begin
                      S_AXIS_tvalid <= 1'b0;
                      S_AXIS_tlast <= 1'b0;
                      S_AXIS_tdata <= 32'd0;
                      cnt <= 0;
                      state <= 0;
                   end
                end
             default: state <=0;
             endcase
        end              
    end
 
 endmodule