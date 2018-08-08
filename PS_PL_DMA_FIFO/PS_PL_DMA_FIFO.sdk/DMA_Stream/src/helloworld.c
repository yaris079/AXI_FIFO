#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_cache.h"          //必须包含该头文件，实现cache操作

#define sendram ((int *)0x10000000)          //发送缓冲区
#define recvram ((int *)0x10001000)          //接收缓冲区
#define sizeofbuffer 32

void print(char *str);
#define WITH_SG 0
#define AXI_DMA_BASE 0x40400000

#define MM2S_DMACR 0
#define MM2S_DMASR 1
#if WITH_SG
#define MM2S_CURDESC 2
#define MM2S_TAILDESC 4
#else
#define MM2S_SA 6
#define MM2S_LENGTH 10
#endif
#define S2MM_DMACR 12
#define S2MM_DMASR 13
#if WITH_SG
#define S2MM_CURDESC14
#define S2MM_TAILDESC16
#else
#define S2MM_DA 18
#define S2MM_LENGTH 22
#endif

void debug_axi_dma_register(unsigned int *p)
{
 printf("MM2S_DMACR = 0x%x\n",*(p+MM2S_DMACR));
 printf("MM2S_DMASR = 0x%x\n",*(p+MM2S_DMASR));
#if WITH_SG
 printf("MM2S_CURDESC = 0x%x\n",*(p+MM2S_CURDESC));
 printf("MM2S_TAILDESC = 0x%x\n",*(p+MM2S_TAILDESC));
#else
 printf("MM2S_SA = 0x%x\n",*(p+MM2S_SA));
 printf("MM2S_LENGTH = 0x%x\n",*(p+MM2S_LENGTH));
#endif
 printf("S2MM_DMACR =0x%x\n",*(p+S2MM_DMACR));
 printf("S2MM_DMACSR =0x%x\n",*(p+S2MM_DMASR));
#if WITH_SG
 printf("S2MM_CURDESC =0x%x\n",*(p+S2MM_CURDESC));
 printf("S2MM_TAILDESC= 0x%x\n",*(p+S2MM_TAILDESC));
#else
 printf("S2MM_DA =0x%x\n",*(p+S2MM_DA));
 printf("S2MM_LENGTH =0x%x\n",*(p+S2MM_LENGTH));
#endif
 printf("\n");
}
void init_axi_dma_simple(unsigned int * p)
{
 //在Debug时监测内存，发现*(p+MM2S_DMACR)=0x10002,此为正常现象。
 //写入0x04对DMA进行软复位。复位完成后寄存器第三位变为0，第二位之中读为1。即显示为0x10002
 *(p+MM2S_DMACR) = 0x04;  //reset send axi dma
 while(*(p+MM2S_DMACR)&0x04);
 *(p+S2MM_DMACR) =0x04;  //reset send axi dma
 while(*(p+S2MM_DMACR)&0x04);
 *(p+MM2S_DMACR)=1;
 while((*(p+MM2S_DMASR)&0x01));
 *(p+S2MM_DMACR)=1;
 while((*(p+S2MM_DMASR)&0x01));
 *(p+MM2S_SA) = (unsigned int )sendram;
 *(p+S2MM_DA) = (unsigned int )recvram;
 Xil_DCacheFlushRange((u32)sendram,sizeofbuffer); //将cache内容同步到DDR2
 *(p+S2MM_LENGTH) =sizeofbuffer;//sizeof(recvram);
 //MM2S_LENGTH
 //表示可用的S2MM缓冲区的长度（以字节为单位）
 //从S2MM通道写入接收数据。 写非零值至该寄存器使S2MM通道可以接收分组数据。
 //在完成S2MM转移时，数量写入S2MM AXI4接口的实际字节更新到S2MM_LENGTH寄存器。
 //注意：此值必须大于或等于最大值
 *(p+MM2S_LENGTH) = sizeofbuffer;//sizeof(sendram);
 while(!(*(p+MM2S_DMASR)&0x1000)); //wait for send ok

}
void init_sendbuffer(int begin)
{
 int i;
 for(i=0;i< sizeofbuffer/4;i++)
 {
  sendram[i]=i*2+begin;
 }
}
void show_recvbuffer()
{
 int i;
 printf("Recv contents are:\n");
 for(i=0;i< sizeofbuffer/4;i++)
 {
  printf("%d\t",recvram[i]);
 }
 printf("\r\n");
}
void show_sendbuffer()
{
 int i;
 printf("Send contents are:\n");
 for(i=0;i< sizeofbuffer/4;i++)
 {
  printf("%d\t",sendram[i]);
 }
 printf("\r\n");
}
int main()
{

 int rxlen;
    init_platform();
    int i;
    for(i=0; i< 1;i++)
    {
    	init_sendbuffer(i);

    	init_axi_dma_simple((unsigned int *)AXI_DMA_BASE);

    	show_sendbuffer();

    	Xil_DCacheInvalidateRange((u32)recvram,sizeofbuffer);      //将DDR2内容同步到cache

    	show_recvbuffer();
    }
    cleanup_platform();

return 0;
}
