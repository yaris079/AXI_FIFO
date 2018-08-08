`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/23 09:38:51
// Design Name: 
// Module Name: data_stream_ip_inst
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


module data_stream_ip_inst #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXIS
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M_AXI
		parameter integer C_M_AXI_TDATA_WIDTH	= 32,
		parameter integer C_M_AXI_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXIS
		input wire  s_axis_aclk,
		input wire  s_axis_aresetn,
		output wire  s_axis_tready,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb,
		input wire  s_axis_tlast,
		input wire  s_axis_tvalid,

		// Ports of Axi Master Bus Interface M_AXI
		input wire  m_axi_aclk,
		input wire  m_axi_aresetn,
		output wire  m_axi_tvalid,
		output wire [C_M_AXI_TDATA_WIDTH-1 : 0] m_axi_tdata,
		output wire [(C_M_AXI_TDATA_WIDTH/8)-1 : 0] m_axi_tstrb,
		output wire  m_axi_tlast,
		input wire  m_axi_tready,
		output wire [(C_M_AXI_TDATA_WIDTH/8)-1 : 0] m_axi_keep
	);
// Instantiation of Axi Bus Interface S_AXIS
    data_stream_ip data_stream_ip (
            .ACLK(s_axis_aclk),
            .ARESETN(s_axis_aresetn),
            .S_AXIS_TREADY(s_axis_tready),
            .S_AXIS_TDATA(s_axis_tdata),
            .S_AXIS_TLAST(s_axis_tstrb),
            .S_AXIS_TVALID(s_axis_tvalid),
            .M_AXIS_TVALID(m_axi_tvalid),
            .M_AXIS_TDATA(m_axi_tdata),
            .M_AXIS_TLAST(m_axi_tlast),
            .M_AXIS_TREADY(m_axi_tready),
            .M_AXIS_TKEEP(m_axi_tkeep)
        );  
endmodule
