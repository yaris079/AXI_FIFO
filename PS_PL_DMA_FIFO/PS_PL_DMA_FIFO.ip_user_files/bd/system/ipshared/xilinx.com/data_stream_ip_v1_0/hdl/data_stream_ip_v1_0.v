
`timescale 1 ns / 1 ps

	module data_stream_ip_v1_0(
	  s_axis_aclk,
      s_axis_aresetn,
      s_axis_tready,
      s_axis_tdata,
      s_axis_tstrb,
      s_axis_tlast,
      s_axis_tvalid,
      m_axi_aclk,
      m_axi_aresetn,
      m_axi_tvalid,
      m_axi_tdata,
      m_axi_tstrb,
      m_axi_tlast,
      m_axi_tready,
      m_axi_tkeep
    );
    
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axis_aclk CLK" *)
    input wire s_axis_aclk;
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_aresetn RST" *)
    input wire s_axis_aresetn;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *)
    output wire s_axis_tready;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *)
    input wire [31 : 0] s_axis_tdata;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TSTRB" *)
    input wire [3 : 0] s_axis_tstrb;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *)
    input wire s_axis_tlast;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *)
    input wire s_axis_tvalid;
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 m_axi_aclk CLK" *)
    input wire m_axi_aclk;
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 m_axi_aresetn RST" *)
    input wire m_axi_aresetn;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axi TVALID" *)
    output wire m_axi_tvalid;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axi TDATA" *)
    output wire [31 : 0] m_axi_tdata;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axi TSTRB" *)
    output wire [3 : 0] m_axi_tstrb;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axi TLAST" *)
    output wire m_axi_tlast;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axi TREADY" *)
    input wire m_axi_tready;
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axi TKEEP" *)
    output wire [3 : 0] m_axi_tkeep;
    
      data_stream_ip_inst #(
        .C_S_AXIS_TDATA_WIDTH(32),
        .C_M_AXI_TDATA_WIDTH(32),
        .C_M_AXI_START_COUNT(32)
      ) inst (
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tready(s_axis_tready),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tstrb(s_axis_tstrb),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tvalid(s_axis_tvalid),
        .m_axi_aclk(m_axi_aclk),
        .m_axi_aresetn(m_axi_aresetn),
        .m_axi_tvalid(m_axi_tvalid),
        .m_axi_tdata(m_axi_tdata),
        .m_axi_tstrb(m_axi_tstrb),
        .m_axi_tlast(m_axi_tlast),
        .m_axi_tready(m_axi_tready),
        .m_axi_tkeep(m_axi_tkeep)
      );
    endmodule