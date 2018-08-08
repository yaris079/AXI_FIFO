
`timescale 1 ns / 1 ps

	module signal_ip_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M_AXIS
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M_AXIS_TKEEP_WIDTH	= 4
		
	)
	(
		// Users to add ports here
        input en,
        input [31:0]length,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M_AXIS
		input wire  m_axis_aclk,
		input wire  m_axis_aresetn,
		output wire  m_axis_tvalid,
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
		output wire [C_M_AXIS_TKEEP_WIDTH-1 : 0] m_axis_tkeep,
		output wire  m_axis_tlast,
		input wire  m_axis_tready		
	);
// Instantiation of Axi Bus Interface M_AXIS
	signal_ip_v1_0_M_AXIS # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
		.C_M_AXIS_TKEEP_WIDTH(C_M_AXIS_TKEEP_WIDTH)
	) signal_ip_v1_0_M_AXIS_inst (
	    .en(en),
        .length(length),
		.M_AXIS_ACLK(m_axis_aclk),
		.M_AXIS_ARESETN(m_axis_aresetn),
		.M_AXIS_TVALID(m_axis_tvalid),
		.M_AXIS_TDATA(m_axis_tdata),
		.M_AXIS_TLAST(m_axis_tlast),
		.M_AXIS_TREADY(m_axis_tready),
		.M_AXIS_TKEEP(m_axis_tkeep)
	);

	// Add user logic here

	// User logic ends

	endmodule
