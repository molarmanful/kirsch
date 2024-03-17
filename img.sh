#!/bin/bash -e

rm -rf out
mkdir -p deps out img

[ ! -f deps/BitsNPicas.jar ] && wget -O deps/BitsNPicas.jar https://github.com/kreativekorp/bitsnpicas/releases/latest/download/BitsNPicas.jar

bnp() {
	java -jar deps/BitsNPicas.jar convertbitmap -f "$3" -o out/"$2.$3" "$1"
}

hb() {
	hb-view --text-file="$1" --font-size=16 -o img/"$2".png --foreground=#86CB92 --background=#1F0318 out/kirsch.ttf
}

bnp src/kirsch.kbitx kirsch ttf

read -r -a list <<<"$(fc-query --format='%{charset}\n' out/kirsch.ttf)"

for range in "${list[@]}"; do
	IFS=- read -r start end <<<"$range"
	if [ "$end" ]; then
		start=$((16#$start))
		end=$((16#$end))
		for ((i = start; i <= end; i++)); do
			printf -v char '\\U%x' "$i"
			printf '%b' "$char"
		done
	else
		printf '%b' "\\U$start"
	fi
done | perl -C -pe 's/\p{M}//g; s/(.)/$1 /g' | grep -oP '.{1,100}' >tmp_chars.txt

for f in prog eng multi scala clojure go svelte apl engalt pretty math box braille; do
	cat txt/"$f".txt
done >tmp_sample.txt

hb tmp_sample.txt sample
hb tmp_chars.txt chars

for f in txt/*; do
	g="${f##*/}"
	g="${g%.*}"
	hb "$f" "$g"
done
