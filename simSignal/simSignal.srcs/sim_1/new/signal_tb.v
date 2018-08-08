`timescale 1ns / 1ps
`define clk_period 10
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/02 14:06:09
// Design Name: 
// Module Name: signal_tb
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


module signal_tb(

    );
    reg clk;
    reg rst;
    reg control;       
    reg [31:0]length;
    reg S_AXIS_tready;
    wire [31:0]S_AXIS_tdata;
    wire [3:0]S_AXIS_tkeep;
    wire S_AXIS_tlast;
    wire S_AXIS_tvalid;
    
    signal signal(
        .clk(clk),
        .rst(rst),
        .control(control),
        .length(length),
        .S_AXIS_tready(S_AXIS_tready),
        .S_AXIS_tdata(S_AXIS_tdata),
        .S_AXIS_tkeep(S_AXIS_tkeep),
        .S_AXIS_tlast(S_AXIS_tlast),
        .S_AXIS_tvalid(S_AXIS_tvalid)
    );
    
    initial begin
        rst = 0;
        clk = 0;
        length = 1024;
        S_AXIS_tready = 1;        
        #20;
        rst = 1;
        control = 1;
        #`clk_period;      
        control = 0;
        #50;
        length = 64;
        control = 1;
    end
    
    always #(`clk_period/2)clk = ~clk;

endmodule
