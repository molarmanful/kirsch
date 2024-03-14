#!/bin/bash -e

rm -rf out
mkdir -p deps out img
true >test.txt

[ ! -f deps/BitsNPicas.jar ] && wget -O deps/BitsNPicas.jar https://github.com/kreativekorp/bitsnpicas/releases/latest/download/BitsNPicas.jar

bnp() {
	java -jar deps/BitsNPicas.jar convertbitmap -f "$3" -o out/"$2.$3" "$1"
}

hb() {
	hb-view --text-file="$1" --font-size=16 -o img/"$2".png --foreground=#86CB92 --background=#1F0318 out/kirsch.ttf
}

bnp src/kirsch.kbitx kirsch ttf

for f in prog eng multi scala clojure go svelte apl engalt pretty math box braille; do
	cat txt/"$f".txt >>test.txt
done

hb test.txt sample

for f in txt/*; do
	g="${f##*/}"
	g="${g%.*}"
	hb "$f" "$g"
done
