
`timescale 1 ns / 1 ps

	module signal_ip_v1_0_M_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// TKEEP WIDTH
		parameter integer C_M_AXIS_TKEEP_WIDTH	= 4
	)
	(
		// Users to add ports here
        input en,
        input [31:0]length,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output reg  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output reg [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		
		output wire [C_M_AXIS_TKEEP_WIDTH-1 : 0] M_AXIS_TKEEP,
		// TLAST indicates the boundary of a packet.
		output reg  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);
	
	// Add user logic here
    assign M_AXIS_TKEEP = 4'b1111;
    
    reg [1:0]state;
    reg [31:0]tmpLength;//用于锁存生成数据的长度
    reg [31:0]cnt;
    
    always@(posedge M_AXIS_ACLK)
    begin
        if(!M_AXIS_ARESETN) begin
         M_AXIS_TVALID <= 1'b0;
         M_AXIS_TDATA <= 32'd0;
         M_AXIS_TLAST <= 1'b0;
         tmpLength <= 32'd0;
         cnt <= 0;
         state <= 0;
        end
        else begin
            case(state)
              0: begin
                  if(en && M_AXIS_TREADY) begin
                     M_AXIS_TVALID <= 1'b1;
                     tmpLength <= length;//在state=1开始那个周期tmpLength更新为length
                     M_AXIS_TDATA <= length;//数据从tmpLength开始
                     state <= 1;
                  end
                  else begin
                     M_AXIS_TVALID <= 1'b0;
                     state <= 0;
                  end
                end
              1:begin
                   if(M_AXIS_TREADY) begin
                       M_AXIS_TDATA <= M_AXIS_TDATA + 1'b1;
                       cnt <= cnt + 1'b1;
                       if(cnt == tmpLength - 2) begin
                          M_AXIS_TLAST <= 1'b1;
                          state <= 2;
                       end
                       else begin
                          M_AXIS_TLAST <= 1'b0;
                          state <= 1;
                       end
                   end
                   else begin
                      M_AXIS_TDATA <= M_AXIS_TDATA;                   
                      state <= 1;
                   end
                end       
              2:begin                   
                   if(!M_AXIS_TREADY) begin
                      M_AXIS_TVALID <= 1'b1;
                      M_AXIS_TLAST <= 1'b1;
                      M_AXIS_TDATA <= M_AXIS_TDATA;
                      state <= 2;
                   end
                   else begin
                      M_AXIS_TVALID <= 1'b0;
                      M_AXIS_TLAST <= 1'b0;
                      M_AXIS_TDATA <= 32'd0;
                      cnt <= 0;
                      state <= 0;
                   end
                end
             default: state <=0;
             endcase
        end              
    end
	// User logic ends

	endmodule
