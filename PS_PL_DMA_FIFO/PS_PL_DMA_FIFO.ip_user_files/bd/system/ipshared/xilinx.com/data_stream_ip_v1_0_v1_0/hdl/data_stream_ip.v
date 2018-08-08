`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/22 23:42:22
// Design Name: 
// Module Name: data_stream_ip
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


module data_stream_ip(
    ACLK,  
    ARESETN,  
    S_AXIS_TREADY,  
    S_AXIS_TDATA,  
    S_AXIS_TLAST,  
    S_AXIS_TVALID,  
    M_AXIS_TVALID,  
    M_AXIS_TDATA,  
    M_AXIS_TLAST,  
    M_AXIS_TREADY, 
    );
    input                                    ACLK;  
    input                                    ARESETN;  
    output                                   S_AXIS_TREADY;  
    input      [31 :0]                      S_AXIS_TDATA;  
    input                                    S_AXIS_TLAST;  
    input                                    S_AXIS_TVALID;  
    output                                   M_AXIS_TVALID;  
    output     [31 :0]                      M_AXIS_TDATA;  
    output                                   M_AXIS_TLAST;  
    input                                    M_AXIS_TREADY;  
    
       localparam NUMBER_OF_INPUT_WORDS  = 8;  
    
    localparam NUMBER_OF_OUTPUT_WORDS = 8;  
    
    localparam Idle  =3'b100;  
    localparam Read_Inputs = 3'b010;  
    localparam Write_Outputs  = 3'b001;  
    
    reg [2:0] state;  
    
    reg [31:0] sum;  
    
    reg [NUMBER_OF_INPUT_WORDS -1:0] nr_of_reads;  
    reg [NUMBER_OF_OUTPUT_WORDS - 1:0] nr_of_writes;  
    
    assign S_AXIS_TREADY  =(state == Read_Inputs);  
    assign M_AXIS_TVALID = (state == Write_Outputs);  
    
    assign M_AXIS_TDATA = sum;  
    assign M_AXIS_TLAST = (nr_of_writes == 1);  
  
    always @(posedge ACLK)  
    begin  // process The_SW_accelerator  
       if(!ARESETN)              // Synchronous reset (active low)  
         begin  
           state        <= Idle;  
            nr_of_reads <= 0;  
            nr_of_writes <=0;  
           sum          <= 0;  
         end  
       else 
         case (state)  
           Idle:  
             if (S_AXIS_TVALID== 1)  
             begin  
              state       <= Read_Inputs;  
              nr_of_reads <= NUMBER_OF_INPUT_WORDS - 1;  
              sum         <= 0;  
             end  
    
          Read_Inputs:  
             if(S_AXIS_TVALID == 1)  
             begin  
              sum         <= sum + S_AXIS_TDATA;  
              if (nr_of_reads == 0)  
                begin  
                  state        <= Write_Outputs;  
                  nr_of_writes <= NUMBER_OF_OUTPUT_WORDS - 1;  
                end  
              else 
                nr_of_reads <= nr_of_reads - 1;  
             end  
    
          Write_Outputs:  
             if(M_AXIS_TREADY == 1)  
             begin  
              if (nr_of_writes == 0)  
                 state <= Idle;  
               else 
                 nr_of_writes <= nr_of_writes - 1;  
             end  
         endcase  
    end  
endmodule

