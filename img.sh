#!/bin/bash -e

rm -rf out
mkdir -p out img
true >test.txt

bnp() {
	java -jar deps/BitsNPicas.jar convertbitmap -f "$3" -o out/"$2.$3" "$1"
}

hb() {
	hb-view --text-file="$1" --font-size=16 -o img/"$2".png out/kirsch.ttf
}

bnp src/kirsch.kbitx kirsch ttf

for f in prog eng multi scala clojure go svelte apl pretty math box braille; do
	cat txt/"$f".txt >>test.txt
done

hb test.txt sample

for f in txt/*; do
	g="${f##*/}"
	g="${g%.*}"
	hb "$f" "$g"
done
