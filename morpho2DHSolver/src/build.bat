call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat" intel64 vs2022

ifort /MD -c func_fbuilding.f90
ifort /MD -c func_cforce.f90
ifort /MD -o ..\iRICsolvers_Morpho2DH\morpho2d.exe *.obj iriclib.lib

pause
