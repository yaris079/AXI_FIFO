// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:data_stream_ip:1.0
// IP Revision: 4

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_data_stream_ip_0_0 (
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
  m_axi_tkeep,
  s_axis_tready,
  s_axis_aclk,
  s_axis_aresetn
);

(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *)
input wire [31 : 0] s_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TSTRB" *)
input wire [3 : 0] s_axis_tstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TLAST" *)
input wire s_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *)
input wire s_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M_AXIS_CLK CLK" *)
input wire m_axi_aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M_AXIS_RST RST" *)
input wire m_axi_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *)
output wire m_axi_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *)
output wire [31 : 0] m_axi_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TSTRB" *)
output wire [3 : 0] m_axi_tstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *)
output wire m_axi_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *)
input wire m_axi_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TKEEP" *)
output wire [3 : 0] m_axi_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *)
output wire s_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S_AXIS_CLK CLK" *)
input wire s_axis_aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S_AXIS_RST RST" *)
input wire s_axis_aresetn;

  data_stream_ip_v1_0 inst (
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
    .m_axi_tkeep(m_axi_tkeep),
    .s_axis_tready(s_axis_tready),
    .s_axis_aclk(s_axis_aclk),
    .s_axis_aresetn(s_axis_aresetn)
  );
endmodule
