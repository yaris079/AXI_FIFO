`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/27 16:04:58
// Design Name: 
// Module Name: fifo_test
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
`define ADDR_WIDTH 8 //��ַλ��
`define DATA_WIDTH 8 //����λ��
`define RAM_WIDTH 8 //RAM ����λ��
`define RAM_DEPTH 256 //RAM ���

module fifo_test(clk_100M, //дʱ��
clk_5M, //��ʱ��
rst_n, // ȫ�ָ�λ�ź�
wr_en, // дʹ�� ����Ч
rd_en, // ��ʹ�� ����Ч
wr_data, //8 λ��������
rd_data, //8 λ�������
wr_full, // д����־ ����Ч
rd_empty); // ���ձ�־ ����Ч
//�����ź�
input clk_100M;
input clk_5M;
input rst_n;
input wr_en;
input rd_en;
input[`DATA_WIDTH-1:0] wr_data;
output reg [`DATA_WIDTH-1:0] rd_data;
output reg wr_full;
output reg rd_empty;
reg [`RAM_WIDTH-1:0] mem[`RAM_DEPTH-1:0]; // 8 λ 256 ��Ԫ
reg[`ADDR_WIDTH-1:0] wr_addr; // 8 λд��ַ
reg[`ADDR_WIDTH-1:0] rd_addr; // 8 ����ַ
reg rd_flag;
reg wr_flag;
//д��ַ�����߼�
always @(posedge clk_100M or negedge rst_n)
begin
if(!rst_n)
begin
wr_addr <= 8'h0;
wr_flag <= 0;
end
else if(!wr_en)
begin
if(!wr_full && (rd_addr!=(wr_addr+1)))
begin
wr_flag <= 1;
wr_addr <= wr_addr + 1'b1;
end
else
wr_flag <= 0;
end
end
// д���ݲ����߼�
always @(posedge clk_100M)
begin
if(!wr_en && !wr_full && wr_flag)
mem[wr_addr] <= wr_data;
end
//д��������־
always @(posedge clk_100M or negedge rst_n)
begin
if(!rst_n)
wr_full <= 0;
else if(rd_addr == (wr_addr+1))
wr_full <= 1'b1;
else
wr_full <= 1'b0;
end
//����ַ�����߼�
always @(posedge clk_5M or negedge rst_n)
begin
if(!rst_n)
begin
rd_flag <= 0;
rd_addr <= 8'd0;
end
else if(!rd_en)
begin
if(!rd_empty && (wr_addr!=(rd_addr+1)))
begin
rd_flag <= 1;
rd_addr <= rd_addr + 1'b1;
end
else
rd_flag <= 0;
end
end
//�����ݲ����߼�
always @(posedge clk_5M)
begin
if(!rd_en && !rd_empty && rd_flag)
rd_data <= mem[rd_addr];
end
//���ղ�����־
always @(posedge clk_5M or negedge rst_n)
begin
if(!rst_n)
rd_empty <= 1'b1;
else if((wr_addr == (rd_addr+1))||(wr_addr == rd_addr))
rd_empty <= 1'b1;
else
rd_empty <= 1'b0;
end
    
endmodule
