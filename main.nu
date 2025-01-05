def main [] {
  mkdir "out"
  cp "src/kirsch.bdf" "out"
  mk_vec
  [1 2 3] | each {|x| mk_x "kirsch" $x }
}

def mk_vec [] {
  bitsnpicas convertbitmap -f "ttf" -o "out/kirsch.ttf" -w 1 -h 1 "src/kirsch.bdf"
  ["si0" "fix" "so1"]
    | each {|x| open $"scripts/($x).py" }
    | str join "\n"
    | fontforge -c $in "out/kirsch.ttf"
  woff2_compress out/kirsch.ttf
}

def mk_x [name: string, x: int] {
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
    | each {|x| open $"scripts/($x).py" }
    | str join "\n"
    | fontforge -c $in $"out/($name).bdf" $"out/($name)." $name
  bdftopcf -o $"out/($name).pcf" "src/kirsch.bdf"
}
