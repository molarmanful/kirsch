#!/bin/bash -e

while getopts "v:n" o; do
	case $o in
	v)
		if [ "$OPTARG" != "" ]; then
			v=$OPTARG
		fi
		;;
	n)
		n=1
		;;
	*) ;;
	esac
done

rm -rf out
mkdir -p deps out

[ ! -f deps/BitsNPicas.jar ] && wget -O deps/BitsNPicas.jar https://github.com/kreativekorp/bitsnpicas/releases/latest/download/BitsNPicas.jar
[ ! -f deps/fontforge ] && wget -O deps/fontforge https://github.com/fontforge/fontforge/releases/download/20230101/FontForge-2023-01-01-a1dad3e-x86_64.AppImage && chmod +x deps/fontforge
[ ! -f deps/font-patcher ] && wget -O deps/FontPatcher.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip && unzip deps/FontPatcher.zip -d deps && chmod +x deps/font-patcher

cp LICENSE out
cp README.md out

bnp() {
	java -jar deps/BitsNPicas.jar convertbitmap -f "$3" -o out/"$2.$3" "$1"
}

ff() {
	s=$(
		cat <<-'END'
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

pcf() {
	if command -v bdftopcf &>/dev/null; then
		perl scripts/ffff.pl <out/"$1".bdf >tmp.bdf
		sed -i "s/^CHARS .*/CHARS $(grep -c '^ENDCHAR' tmp.bdf)/" tmp.bdf
		bdftopcf -o out/"$1".pcf tmp.bdf
	fi
}

nerd() {
	if [ "$n" != "" ]; then
		deps/fontforge -script "$PWD"/deps/font-patcher "$PWD"/out/kirsch.ttf -out "$PWD"/out --careful -c "$@"
	fi
}

bnp src/kirsch.kbitx kirsch ttf
nerd
nerd -s
bnp src/kirsch.kbitx kirsch bdf
sed -i -e '/^FONT/s/-[pc]-/-M-/i' -e '/^FONT/s/-80-/-50-/' out/kirsch.bdf
ff kirsch
pcf kirsch

if command -v bdfresize &>/dev/null; then
	for n in 2 3; do
		name=kirsch${n}x
		bdfresize -f 2 out/kirsch.bdf >out/"$name".bdf
		sed -i -e 's/^iso.*-FONT/FONT/g' -e "s/kirsch/$name/g" out/"$name".bdf
		ff "$name"
		pcf "$name"
	done
fi

if command -v bdfresize &>/dev/null; then
	woff2 out/kirsch.ttf
fi

rm -f out/*-*.bdf

zip -r "out/kirsch_$v.zip" out/*
