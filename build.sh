#!/bin/bash -e

. ./fns.sh

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

cp README.md out
cp LICENSE out
cp AUTHORS out

bnp_dep
nerd_dep

cp src/kirsch.bdf out
bnp src/kirsch.bdf kirsch ttf
ttfix kirsch
ff kirsch
pcf kirsch
if [ "$n" != "" ]; then
  nerd
  nerd -s
fi

if command -v bdfresize &>/dev/null; then
  for n in 2 3; do
    name=kirsch${n}x
    bdfresize -f "$n" out/kirsch.bdf >out/"$name".bdf
    ff "$name"
    pcf "$name"
  done
fi

if command -v woff2_compress &>/dev/null; then
  woff2_compress out/kirsch.ttf
fi

rm -f out/*-*.bdf

zip -r "out/kirsch_$v.zip" out/*
