#!/bin/bash -e

while getopts ":v:" o; do
	case $o in
	v)
		[ "$OPTARG" != "" ] && v="_$OPTARG"
		;;
	*) ;;
	esac
done

rm -rf out
mkdir -p deps out

[ ! -f deps/BitsNPicas.jar ] && wget -O deps/BitsNPicas.jar "https://github.com/kreativekorp/bitsnpicas/releases/latest/download/BitsNPicas.jar"

cp LICENSE out

# kbitx -> bdf
java -jar deps/BitsNPicas.jar convertbitmap -f bdf -o "out/kirsch$v.bdf" src/kirsch.kbitx
bdfresize -f 2 "out/kirsch$v.bdf" >"out/kirsch_2x$v.bdf"

# kbitx -> otb
java -jar deps/BitsNPicas.jar convertbitmap -f otb -o "out/kirsch$v.otb" src/kirsch.kbitx
bdfresize -f 2 "out/kirsch$v.otb" >"out/kirsch_2x$v.otb"

# kbitx -> ttf
java -jar deps/BitsNPicas.jar convertbitmap -f ttf -o "out/kirsch$v.ttf" src/kirsch.kbitx

rm -f out/*.afm
zip -r "out/kirsch$v.zip" out/*
