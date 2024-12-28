#!/bin/bash -e

rm -rf out
mkdir -p deps out img

. ./fns.sh

bnp_dep

bnp src/kirsch.bdf kirsch ttf

echo 'chars...'
readarray -t list < <(grep '^ENCODING [^-]' src/kirsch.bdf | cut -d' ' -f2)
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
done | perl -pe 's/\p{M}/ $&/g' | grep -Ew 'U\+\w+ . +[^ ]' >>txt/map.txt

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
