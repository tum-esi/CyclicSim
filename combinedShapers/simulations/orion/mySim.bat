@echo off
setlocal enabledelayedexpansion

REM Set the number of simulations to run
set NUM_SIMULATIONS=10

REM Set the path to the scavetool executable
set SCAVETOOL_PATH="C:/omnetpp-6.0.1/bin/opp_scavetool.exe"

REM Loop to run the simulations
for /l %%i in (1,1,%NUM_SIMULATIONS%) do (
    REM Run the simulation with the current configuration

    set OUTPUT_DIR=C:/Users/comet/Documents/MT_GitRepo/inet-testsetup/Programming/IVN2/testcases/CBS_TAS/Orion/TC1_1/results/run%%i
	mkdir %OUTPUT_DIR%
    
    cd C:/Users/comet/Documents/MT_GitRepo/inet-testsetup/Programming/IVN2/testcases/CBS_TAS/Orion/TC1_1
    
    set /a index=%%i - 1
    opp_run -l ../../../../IVN2.exe -r !index! -m -n ../../../..;../../../../../inet/examples;../../../../../inet/showcases;../../../../../inet/src;../../../../../inet/tests/validation;../../../../../inet/tests/networks;../../../../../inet/tutorials;../../../.. -x inet.common.selfdoc;inet.linklayer.configurator.gatescheduling.z3;inet.emulation;inet.showcases.visualizer.osg;inet.examples.emulation;inet.showcases.emulation;inet.transportlayer.tcp_lwip;inet.applications.voipstream;inet.visualizer.osg;inet.examples.voipstream --image-path=../../../../../inet/images -l ../../../../../inet/src/INET omnetpp.ini -u Cmdenv --result-dir="!OUTPUT_DIR!" --cmdenv-express-mode=true

)

REM Loop to run scavetool
for /l %%j in (1,1,%NUM_SIMULATIONS%) do (
	cd C:/Users/comet/Documents/MT_GitRepo/inet-testsetup/Programming/IVN2/testcases/CBS_TAS/Orion/TC1_1/results/run%%j
	%SCAVETOOL_PATH% export -f "module=~**.sink AND ("meanBitLifeTimePerPacket:vector")" -o output.csv -F CSV-R *.vec
)

echo All simulations completed!
pause