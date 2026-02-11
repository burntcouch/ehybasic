REM create msbasic for hydra
REM
del temp\*.o
h:\cc65\bin\ca65.exe -D hydra16 -l temp\hydrabas.txt -o temp\hydrabas.o msbasic.s
h:\cc65\bin\ld65 -vm -C hydra.cfg temp\hydrabas.o -o temp\hydrabas.bin -Ln temp\hydrabas.lbl