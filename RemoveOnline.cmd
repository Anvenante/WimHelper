@echo off

rem ��ȡ����ԱȨ��
pushd "%~dp0" && Dism 1>nul 2>nul || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 "%*"","","runas",1)(window.close) && Exit /B 1
rem ���ñ���
color 1F
mode con cols=120
cls
setlocal EnableDelayedExpansion
set NSudo="%~dp0Bin\%PROCESSOR_ARCHITECTURE%\NSudo.exe"
set "Dism=Dism.exe /NoRestart /LogLevel:1"

for %%i in (
Microsoft-Windows-Holographic-Desktop-Analog-WOW64-Package
) do call :RemoveComponent "%%i"
goto :Exit

rem �Ƴ�ϵͳ��� [ %~1 : ������� ]
:RemoveComponent
setlocal
rem �����������
for /f "tokens=* delims=" %%f in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "%~1" ^| findstr /i "%~1"') do ( 
    %NSudo% reg add "%%f" /v Visibility /t REG_DWORD /d 1 /f
    %NSudo% reg add "%%f" /v DefVis /t REG_DWORD /d 2 /f
    %NSudo% reg delete "%%f\Owners" /f
)
for /f "tokens=3 delims=: " %%f in ('%Dism% /English /Online /Get-Packages ^| findstr /i "%~1" ^| findstr /v zh-CN') do (
    echo.�Ƴ���� [%%f]
    %Dism% /Online /Remove-Package /PackageName:"%%f" /Quiet
)
endlocal
goto :eof

:Exit
pause