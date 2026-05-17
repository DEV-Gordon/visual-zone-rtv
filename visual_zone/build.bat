@echo off
cd /d "%~dp0"

echo packing...
"C:\Program Files\7-Zip\7z.exe" a -tzip "visual_zone.zip" * -xr!"*.bat" -xr!"*.zip" -xr!"*.vmz"

echo rename to .vmz...
if exist "visual_zone.vmz" del "visual_zone.vmz"
rename "visual_zone.zip" "visual_zone.vmz"

echo ready.
pause