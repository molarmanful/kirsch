def main [out: path, --nerd] {
  let src = "src/kirsch.bdf"
  let ttf = $out | path join "kirsch.ttf"

  cp $src $out
  mk_vec $ttf
  if $nerd { mk_nerd $ttf $out }
  [1 2 3] | each { mk_x "kirsch" $in }
}

def mk_vec [ttf: path] {
  bitsnpicas convertbitmap -f "ttf" -o $ttf -w 1 -h 1 "src/kirsch.bdf"
  ["si0" "fix" "so1"]
    | each { open $"scripts/($in).py" }
    | str join "\n"
    | fontforge -c $in $ttf
  woff2_compress $ttf
}

def mk_nerd [ttf: path, out: path] {
  nerd-font-patcher $ttf -out $out --careful -c
  nerd-font-patcher $ttf -out $out --careful -c -s
}

def mk_x [name: string, x = 1] {
  if $x <= 1 {
    mk_rest $name
  } else {
    let nm = $"($name)($x)x"
    bdfresize -f $x "out/kirsch.bdf" | save $"out/($nm).bdf"
    mk_rest $nm
  }
}

def mk_rest [name: string] {
  ["si0" "si1" "fix" "so0"]
    | each { open $"scripts/($in).py" }
    | str join "\n"
    | fontforge -c $in $"out/($name).bdf" $"out/($name)." $name
  bdftopcf -o $"out/($name).pcf" "src/kirsch.bdf"
}
