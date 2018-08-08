@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xsim fifo_test_IB_behav -key {Behavioral:sim_1:Functional:fifo_test_IB} -tclbatch fifo_test_IB.tcl -view C:/Users/yaris/Desktop/project_1/fifo_test_IB_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
