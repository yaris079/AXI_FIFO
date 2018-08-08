`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2018/08/06 13:39:07
// Design Name:
// Module Name: tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:

// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tb(

);
    
    reg FCLK_CLK1_S;
    reg FCLK_CLK2_M;
    wire [31:0]M_AXIS_tdata;
    wire [3:0]M_AXIS_tkeep;
    wire M_AXIS_tlast;
    wire M_AXIS_tready;
    wire M_AXIS_tvalid;
    
    reg [31:0]S_AXIS_tdata;
    wire [3:0]S_AXIS_tkeep;
    reg S_AXIS_tlast;
    wire S_AXIS_tready;
    reg S_AXIS_tvalid;
    
    reg peripheral_aresetn;
    
    assign M_AXIS_tready = 1'b1;
    assign S_AXIS_tkeep = 4'b1111;
    reg   [1:0]state;
    
    always #3 FCLK_CLK2_M = ~FCLK_CLK2_M; //读时钟
    always #2 FCLK_CLK1_S = ~FCLK_CLK1_S; //写时钟
    
    initial begin
        peripheral_aresetn = 0; FCLK_CLK1_S = 0;
        FCLK_CLK2_M = 1;
        #25 peripheral_aresetn = 1;
    end
    
    always@(posedge FCLK_CLK1_S)
    begin
        if(!peripheral_aresetn) begin
            S_AXIS_tvalid <= 1'b0;
            S_AXIS_tdata <= 32'd0;
            S_AXIS_tlast <= 1'b0;
            state <=0;
        end
        else begin
            case(state)
                0: begin
                    if (S_AXIS_tready) begin
                        S_AXIS_tvalid <= 1'b1;
                        state <= 1;
                    end
                end
                1:begin
                    if(S_AXIS_tready) begin
                        S_AXIS_tdata <= S_AXIS_tdata + 1'b1;
                        if(S_AXIS_tdata == 32'd4096) begin
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
                        state <= 0;
                    end
                end
                default: state <=0;
            endcase
        end
    end

    fifo_generator_0 fifo(              //复位低电平有效
        .m_axis_tdata(M_AXIS_tdata),
        .m_axis_tkeep(M_AXIS_tkeep),
        .m_axis_tlast(M_AXIS_tlast),
        .m_axis_tready(M_AXIS_tready),
        .m_axis_tvalid(M_AXIS_tvalid),
        .s_axis_tdata(S_AXIS_tdata),
        .s_axis_tkeep(S_AXIS_tkeep),
        .s_axis_tlast(S_AXIS_tlast),
        .s_axis_tready(S_AXIS_tready),
        .s_axis_tvalid(S_AXIS_tvalid),
        .m_aclk(FCLK_CLK2_M),
        .s_aclk(FCLK_CLK1_S),
        .s_aresetn(peripheral_aresetn)
    );


endmodule