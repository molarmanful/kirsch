#!/bin/bash -e

bnp_dep() {
  if [ ! -f deps/BitsNPicas.jar ]; then
    wget -O deps/BitsNPicas.jar https://github.com/kreativekorp/bitsnpicas/releases/latest/download/BitsNPicas.jar
  fi
}

nerd_dep() {
  if [ ! -f deps/font-patcher ]; then
    wget -O deps/FontPatcher.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip
    unzip deps/FontPatcher.zip -d deps
    chmod +x deps/font-patcher
  fi
}

bnp() {
  java -jar deps/BitsNPicas.jar convertbitmap -f "$3" -o out/"$2.$3" -w 1 -h 1 "$1"
}

ff() {
  nl=$'\n'
  si0=$(cat scripts/si0.py)
  si1=$(cat scripts/si1.py)
  so0=$(cat scripts/so0.py)
  so1=$(cat scripts/so1.py)
  fix=$(cat scripts/fix.py)
  fontforge -c "$si0$nl$si1$nl$fix$nl$so0" out/"$1".bdf out/"$1". "$1"
}

ttfix() {
  nl=$'\n'
  si0=$(cat scripts/si0.py)
  so1=$(cat scripts/so1.py)
  fix=$(cat scripts/fix.py)
  fontforge -c "$si0$nl$fix$nl$so1" out/"$1".ttf
}

pcf() {
  if command -v bdftopcf &>/dev/null; then
    perl scripts/ffff.pl <out/"$1".bdf >tmp.bdf
    sed -i "s/^CHARS .*/CHARS $(grep -c '^ENDCHAR' tmp.bdf)/" tmp.bdf
    bdftopcf -o out/"$1".pcf tmp.bdf
  fi
}

nerd() {
  fontforge -script deps/font-patcher out/kirsch.ttf -out out --careful -c "$@"
}

hb() {
  hb-view --text-file="$1" --font-size=16 -o img/"$2".png --foreground=#86CB92 --background=#1F0318 out/kirsch.ttf
}
