sh build.sh
OUT=$?

if [ $OUT -eq 0 ];then
    x64 bin/out.prg
else
    exit 1
fi


