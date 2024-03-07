#!/bin/bash -e

while getopts ":v:" o; do
	case $o in
	v)
		if [ "$OPTARG" != "" ]; then
			v=$OPTARG
		fi
		;;
	*) ;;
	esac
done

rm -rf out
mkdir -p deps out img

[ ! -f deps/BitsNPicas.jar ] && wget -O deps/BitsNPicas.jar https://github.com/kreativekorp/bitsnpicas/releases/latest/download/BitsNPicas.jar
[ ! -f deps/fontforge ] && wget -O deps/fontforge https://github.com/fontforge/fontforge/releases/download/20230101/FontForge-2023-01-01-a1dad3e-x86_64.AppImage && chmod +x deps/fontforge

cp LICENSE out
cp README.md out
true >test.txt

bnp() {
	java -jar deps/BitsNPicas.jar convertbitmap -f "$3" -o out/"$2.$3" "$1"
}

ff() {
	s=$(
		cat <<-END
			f = open(argv[1])
			f.encoding = "UnicodeFull"
			f.fullname = argv[3]
			f.fontname = argv[3]
			f.generate(argv[2], "otb")
			f.generate(argv[2] + "dfont", "sbit")
		END
	)
	deps/fontforge -c "$s" "$PWD"/out/"$1".bdf "$PWD"/out/"$1". "$1"
}

hb() {
	hb-view --text-file="$1" --font-size=16 -o img/"$2".png out/kirsch.ttf
}

bnp src/kirsch.kbitx kirsch ttf
bnp src/kirsch.kbitx kirsch bdf
sed -i -e '/^FONT/s/-[pc]-/-M-/i' -e '/^FONT/s/-80-/-50-/' out/kirsch.bdf
ff kirsch

bdfresize -f 2 out/kirsch.bdf >out/kirsch2x.bdf
sed -i -e 's/^iso.*-FONT/FONT/g' -e 's/kirsch/kirsch2x/g' out/kirsch2x.bdf
ff kirsch2x

rm -f out/*-*.bdf

zip -r "out/kirsch_$v.zip" out/*

for f in prog eng multi scala clojure go svelte apl pretty math box; do
	cat txt/"$f".txt >>test.txt
done

hb test.txt sample

for f in txt/*; do
	g="${f##*/}"
	g="${g%.*}"
	hb "$f" "$g"
done
