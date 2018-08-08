@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 930cce6aafeb48538684a2507fddcd47 -m64 --debug typical --relax --mt 2 -L fifo_generator_v13_0_1 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot fifo_test_IB_behav xil_defaultlib.fifo_test_IB xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
