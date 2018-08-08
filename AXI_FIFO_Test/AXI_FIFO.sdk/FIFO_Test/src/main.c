#include "dma_intr.h"
#include "timer_intr.h"
#include "sys_intr.h"
#include "xgpio.h"
#include "xtmrctr.h"

static XScuGic Intc; //GIC
static XAxiDma AxiDma0Rx;
static XAxiDma AxiDma1Tx;
static XScuTimer Timer;//timer
static XTmrCtr TimerInstancePtr;

volatile u32 RX_success;
volatile u32 TX_success;

volatile u32 RX_ready=1;
volatile u32 TX_ready=0;

#define TIMER_LOAD_VALUE    166666665 //0.5S

#define AXI_GPIO_LED_DEV_ID	        XPAR_AXI_GPIO_0_DEVICE_ID
#define AXI_GPIO_DEV_ID	        XPAR_AXI_GPIO_1_DEVICE_ID

#define GTC_BASE 0xF8F00200              //Global Timer基地址
#define GTC_CTRL    0x08                  //控制寄存器偏移量
#define GTC_DATL    0x00                  //数据寄存器（低32bit）
#define GTC_DATH    0x04                  //数据寄存器（高32bit）

#define CLK_3x2x    333333333            //定时器输入时钟频率

char oled_str[17]="";

int Tries = NUMBER_OF_TRANSFERS;
int i;
int Index;
int ledStatus;
int txLength=0;
int rxLength=0;
int dataLength;
u32 *TxBufferPtr= (u32 *)DATA_BUFFER_BASE;
u32 *RxBufferPtr=(u32 *)DATA_BUFFER_BASE;
u32 Value=0;
float speed_tx;
float speed_rx;
static XGpio Led;
XGpio Gpio;

void tic(void)
{
    *((volatile int*)(GTC_BASE+GTC_CTRL)) = 0x00;
    *((volatile int*)(GTC_BASE+GTC_DATL)) = 0x00000000;
    *((volatile int*)(GTC_BASE+GTC_DATH)) = 0x00000000;     //清零定时器的计数值
    *((volatile int*)(GTC_BASE+GTC_CTRL)) = 0x01;
}

double toc(void)
{
    *((volatile int*)(GTC_BASE+GTC_CTRL)) = 0x00;
    long long j=*((volatile int*)(GTC_BASE+GTC_DATH));
    double elapsed_time = j<<32;
    j=*((volatile int*)(GTC_BASE+GTC_DATL));              //读取64bit定时器值，转换为double
    elapsed_time+=j;
    elapsed_time/=CLK_3x2x;
    elapsed_time*=1000;
    printf("Elapsed time is %.3f ms.\r\n",elapsed_time);
    return elapsed_time;
}

int get_length(XAxiDma *InstancePtr, UINTPTR BuffAddr, int Direction){
	int RingIndex = 0;
	u32 length;
	if(Direction == XAXIDMA_DMA_TO_DEVICE){
		length = XAxiDma_ReadReg(InstancePtr->TxBdRing.ChanBase,
							XAXIDMA_BUFFLEN_OFFSET);
	}
	else if(Direction == XAXIDMA_DEVICE_TO_DMA){
		length = XAxiDma_ReadReg(InstancePtr->RxBdRing[RingIndex].ChanBase,
							XAXIDMA_BUFFLEN_OFFSET);
	}
	return length;
}

int axi_dma_test()
{
	int Status;
	TxDone = 0;
	RxDone = 0;
	Error = 0;
	double time;
	xil_printf("--- Begin Test --- \r\n");
	/*
	for(Index = 0; Index < (MAX_PKT_LEN+1)/4; Index ++) {//一个数是4个字节
			TxBufferPtr[Index] = Value;
			Value = (Value + 1) & 0xFFFFF;
	}
	*/
	/* Flush the SrcBuffer before the DMA transfer, in case the Data Cache
	 * is enabled
	 */
	/*Xil_DCacheFlushRange((u32)TxBufferPtr, MAX_PKT_LEN);*/
	tic();
	Timer_start(&Timer);
	while(1)
	//for(i = 0; i < Tries; i ++)
	{
		//RX DMA Transfer
		if(RX_ready)
		{
			if (RX_success % 100 == 0) ledStatus = ledStatus | 0x1;
			XGpio_DiscreteWrite(&Led, 1, ledStatus);
			RX_ready=0;
			Status = XAxiDma_SimpleTransfer(&AxiDma0Rx,(u32)RxBufferPtr,
					 (u32)(MAX_PKT_LEN), XAXIDMA_DEVICE_TO_DMA);

			if (Status != XST_SUCCESS) {return XST_FAILURE;}
		}

		if(RxDone)
		{
			if (RX_success % 100 == 0) ledStatus = 0;
			XGpio_DiscreteWrite(&Led, 1, ledStatus);
			RxDone=0;
			//RX_ready=1;
			RX_success++;
			rxLength+=get_length(&AxiDma0Rx,(u32)RxBufferPtr,XAXIDMA_DEVICE_TO_DMA);
			TX_ready = 1;
		}

		//TX DMA Transfer
		if(TX_ready)
		{
			if (TX_success % 100 == 0) ledStatus = ledStatus | 0x2;
			XGpio_DiscreteWrite(&Led, 1, ledStatus);
			TX_ready=0;
			dataLength = get_length(&AxiDma0Rx,(u32)RxBufferPtr,XAXIDMA_DEVICE_TO_DMA);
			Status = XAxiDma_SimpleTransfer(&AxiDma1Tx,(u32) TxBufferPtr,
					(u32)(dataLength), XAXIDMA_DMA_TO_DEVICE);

			if (Status != XST_SUCCESS) {return XST_FAILURE;}
		}

		if(TxDone)
		{
			if (TX_success % 100 == 0) ledStatus = 0;
			XGpio_DiscreteWrite(&Led, 1, ledStatus);
			TxDone=0;
			//TX_ready=1;
			TX_success++;
			txLength+=get_length(&AxiDma1Tx,(u32) TxBufferPtr,XAXIDMA_DMA_TO_DEVICE);
			RX_ready = 1;
		}

		if(usec==20)
		{
			usec=0;
			time = toc();
			time = time / 1000;//toc获取的时间单位为ms
			sprintf(oled_str,"RX_NUM=%d",(int)RX_success);
			xil_printf("%s\r\n",oled_str);
			speed_rx = rxLength/1024.0/1024.0/time;
			sprintf(oled_str,"RX_SPEED=%.2fMB/S",speed_rx);
			xil_printf("%s\r\n",oled_str);

			sprintf(oled_str,"TX_NUM=%d",(int)TX_success);
			xil_printf("%s\r\n",oled_str);
			speed_tx = txLength/1024.0/1024.0/time;
			sprintf(oled_str,"TX_SPEED=%.2fMB/S",speed_tx);
			xil_printf("%s\r\n",oled_str);
			xil_printf("\r\n\n");
			RX_success=0;
			TX_success=0;
			rxLength=0;
			txLength=0;
			tic();
		}

		if (Error) {
			xil_printf("Failed test transmit%s done, "
			"receive%s done\r\n", TxDone? "":" not",
							RxDone? "":" not");
			goto Done;
		}

	}

	/* Disable TX and RX Ring interrupts and return success */
	DMA_DisableIntrSystem(&Intc, TX_INTR_ID, RX_INTR_ID);
Done:
	xil_printf("--- Exiting Test --- \r\n");
	return XST_SUCCESS;

}

void init_intr_sys()
{
	DMA_Intr_Init(&AxiDma0Rx,XPAR_AXIDMA_0_DEVICE_ID);//initial interrupt system
	DMA_Intr_Init(&AxiDma1Tx,XPAR_AXIDMA_1_DEVICE_ID);
	Timer_init(&Timer,TIMER_LOAD_VALUE,0);
	Init_Intr_System(&Intc); // initial DMA interrupt system
	Setup_Intr_Exception(&Intc);
	DMA_Setup_RX_Intr_System(&Intc,&AxiDma0Rx,RX_INTR_ID);//setup dma interrpt system
	DMA_Setup_TX_Intr_System(&Intc,&AxiDma1Tx,TX_INTR_ID);
	Timer_Setup_Intr_System(&Intc,&Timer,TIMER_IRPT_INTR);
	DMA_Intr_Enable(&Intc,&AxiDma0Rx,0);
	DMA_Intr_Enable(&Intc,&AxiDma1Tx,1);
	ledStatus = 0;
}

int main()
{
	XGpio_Initialize(&Led, AXI_GPIO_LED_DEV_ID);
	XGpio_SetDataDirection(&Led, 1, 0);
	XGpio_Initialize(&Gpio, AXI_GPIO_DEV_ID);
	XGpio_SetDataDirection(&Gpio, 1, 0);
	init_intr_sys();
	XGpio_DiscreteWrite(&Led, 1, 0);
	XGpio_DiscreteWrite(&Gpio, 1, 1);
	axi_dma_test();
	XGpio_DiscreteWrite(&Led, 1, 0);
	return 0;
}


