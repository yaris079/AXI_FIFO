`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/27 16:07:42
// Design Name: 
// Module Name: fifo_test_IB
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


module fifo_test_IB(

    );
    reg clk_15M;
    reg clk_5M;
    reg rst_n; // 全局复位信号
    reg wr_en; // 写使能
    reg rd_en; // 读使能
    reg[17:0] wr_data;
    wire[17:0] rd_data;
    wire wr_full;
    wire wr_almost_full;
    wire rd_empty;
    wire rd_almost_empty;
    reg[16:0] cnt;
    wire[9:0] rd_data_count;
    wire[9:0] wr_data_count;
  fifo_generator_0 fifo1(
    .rst(~rst_n),
    .wr_clk(clk_15M),
    .rd_clk(clk_5M),
    .din(wr_data),
    .wr_en(wr_en),
    .rd_en(rd_en),    
    .dout(rd_data),
    .full(wr_full),
    .almost_full(wr_almost_full),
    .empty(rd_empty),
    .almost_empty(rd_almost_empty),
    .rd_data_count(rd_data_count),
    .wr_data_count(wr_data_count));
    always #15 clk_5M = ~clk_5M; //读时钟
    always #5 clk_15M = ~clk_15M; //写时钟
    initial
    begin
    rst_n = 0; clk_15M = 0;
    clk_5M = 1; wr_en = 0;
    rd_en = 0;
    #25 rst_n = 1;
    wr_en=1;rd_en=1;
    end
    always @(posedge clk_15M or negedge rst_n)
    begin
    if(!rst_n)
    wr_data <= 8'd0;
    else
    wr_data <= cnt;
    end
    always @(posedge clk_15M or negedge rst_n)
    begin
    if(!rst_n)
    cnt <= 16'd0;
    else if (cnt == 16'd2048)
    wr_en = 0;
    else
    cnt <= cnt + 1'b1;
    end
endmodule
