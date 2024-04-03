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
bnp src/kirsch.kbitx kirsch bdf

echo 'chars...'
readarray -t list < <(grep '^ENCODING ' out/kirsch.bdf | cut -d' ' -f2)
for n in "${list[@]}"; do
	char=$(printf '\\U%x' "$n")
	printf '%b' "$char"
done | perl -C -pe 's/\p{M}//g; s/(.)/$1 /g; $_=join("\n", /.{1,100}/g)' >txt/chars.txt

echo 'map...'
i=0
echo $'           0 1 2 3 4 5 6 7 8 9 a b c d e f\n         ┌────────────────────────────────' >txt/map.txt
for ((n = 1; n <= list[-1] / 16; n++)); do
	printf 'U+%05x_ │' "$n"
	for m in {0..15}; do
		u=$((n * 16 + m))
		printf ' '
		if [ "$u" == "${list[i]}" ]; then
			printf -v char '\\U%x' "$u"
			printf '%b' "$char"
			i=$((i + 1))
		else
			printf ' '
		fi
	done
	printf '\n'
done | perl -pe 's/\p{M}/ $&/g' | grep -Ew 'U+[a-z0-9_]+ | +[^ ]' >>txt/map.txt

echo 'samples...'
for f in prog eng multi scala clojure go svelte apl engalt pretty math box braille; do
	cat txt/"$f".txt
done >txt/sample.txt

cat txt/header.txt txt/sample.txt >txt/all.txt

for f in txt/*; do
	g="${f##*/}"
	g="${g%.*}"
	hb "$f" "$g"
done
