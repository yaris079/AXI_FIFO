//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
//Date        : Wed Jul 25 14:55:15 2018
//Host        : DESKTOP-HDMLCJ0 running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    led_tri_o);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [1:0]led_tri_o;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FCLK_CLK1;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  
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
  wire [1:0]debug_tri_i;
  wire gpio_rtl_tri_o;
  wire [1:0]led_tri_o;
  wire [0:0]peripheral_aresetn;

  assign M_AXIS_tready = 1'b1;
  assign S_AXIS_tkeep = 4'b1111;
  reg   [1:0]state;
  assign debug_tri_i = state;
always@(posedge FCLK_CLK1)
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
              if(gpio_rtl_tri_o && S_AXIS_tready) begin
                 S_AXIS_tvalid <= 1'b1;
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
                   if(S_AXIS_tdata == 32'd1022) begin
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

  system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK1(FCLK_CLK1),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .M_AXIS_tdata(M_AXIS_tdata),
        .M_AXIS_tkeep(M_AXIS_tkeep),
        .M_AXIS_tlast(M_AXIS_tlast),
        .M_AXIS_tready(M_AXIS_tready),
        .M_AXIS_tvalid(M_AXIS_tvalid),
        .S_AXIS_tdata(S_AXIS_tdata),
        .S_AXIS_tkeep(S_AXIS_tkeep),
        .S_AXIS_tlast(S_AXIS_tlast),
        .S_AXIS_tready(S_AXIS_tready),
        .S_AXIS_tvalid(S_AXIS_tvalid),
        .debug_tri_i(debug_tri_i),
        .gpio_rtl_tri_o(gpio_rtl_tri_o),
        .led_tri_o(led_tri_o),
        .peripheral_aresetn(peripheral_aresetn));
endmodule
