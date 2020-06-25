mkdir -p build
mkdir -p bin

cd src
acme -o ../bin/out.prg -f cbm -l ../build/labels.txt -r ../build/report.txt main.asm
OUT=$?
cd ..

if [ $OUT -eq 0 ];then
    exit 0
else
    exit 1
fi

