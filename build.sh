#!/bin/bash -e

. ./fns.sh

rm -rf out
mkdir -p deps out

bnp_dep
nerd_dep

cp src/kirsch.bdf out
bnp src/kirsch.bdf kirsch ttf
ttfix kirsch
ff kirsch
pcf kirsch
if [ "$NERD" != "" ]; then
  nerd
  nerd -s
fi

if command -v bdfresize &>/dev/null; then
  IFS=',' read -r -a xs <<<"$XS"
  for n in "${xs[@]}"; do
    name=kirsch${n}x
    bdfresize -f "$n" out/kirsch.bdf >out/"$name".bdf
    ff "$name"
    pcf "$name"
  done
fi

if command -v woff2_compress &>/dev/null; then
  woff2_compress out/kirsch.ttf
fi
