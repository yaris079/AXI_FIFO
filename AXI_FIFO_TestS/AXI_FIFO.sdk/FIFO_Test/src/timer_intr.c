#include "timer_intr.h"
#include "xgpio.h"
volatile int usec;
extern  XGpio Gpio;

static void TimerIntrHandler(void *CallBackRef)
{
    XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
    /*已经不需要使能数据包的创造，改为连续不断的创造数据包*/
    /*
    //1666666为5ms计时
    u32 num=rand()%1666666*4+1666666*6;//30-50ms随机
	XScuTimer_LoadTimer(TimerInstancePtr, num);
	*/
    XScuTimer_ClearInterruptStatus(TimerInstancePtr);//重新开始计时
    /*
    XGpio_DiscreteWrite(&Gpio, 1, 1);
    XGpio_DiscreteWrite(&Gpio, 1, 0);
    */
    usec++;
}

void Timer_start(XScuTimer *TimerPtr)
{
	    XScuTimer_Start(TimerPtr);
}

void Timer_Setup_Intr_System(XScuGic *GicInstancePtr,XScuTimer *TimerInstancePtr, u16 TimerIntrId)
{
        XScuGic_Connect(GicInstancePtr, TimerIntrId,
                        (Xil_ExceptionHandler)TimerIntrHandler,//set up the timer interrupt
                        (void *)TimerInstancePtr);

        XScuGic_Enable(GicInstancePtr, TimerIntrId);//enable the interrupt for the Timer at GIC
        XScuTimer_EnableInterrupt(TimerInstancePtr);//enable interrupt on the timer
 }

int Timer_init(XScuTimer *TimerPtr,u32 Load_Value,u32 DeviceId)
{
     XScuTimer_Config *TMRConfigPtr;     //timer config
     //私有定时器初始化
     TMRConfigPtr = XScuTimer_LookupConfig(DeviceId);
     XScuTimer_CfgInitialize(TimerPtr, TMRConfigPtr,TMRConfigPtr->BaseAddr);
     //XScuTimer_SelfTest(&Timer);
     //加载计数周期，私有定时器的时钟为CPU的一半，为333MHZ,如果计数1S,加载值为1sx(333x1000x1000)(1/s)-1=0x13D92D3F
     XScuTimer_LoadTimer(TimerPtr, Load_Value);//F8F00600+0=reg=F8F00600
     //自动装载
     XScuTimer_EnableAutoReload(TimerPtr);//F8F00600+8=reg=F8F00608

     return 1;
}
