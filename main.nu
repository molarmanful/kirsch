def main [src: path, out: path, --nerd] {
  let name = $src | path parse | get stem
  let ttf = $out | path join $'($name).ttf'

  cp $src $out
  mk_vec $src $ttf
  if $nerd { mk_nerd $ttf $out }
  [1 2 3] | each { mk_x $src $name $in }
}

def mk_vec [src: path, ttf: path] {
  bitsnpicas convertbitmap -f 'ttf' -o $ttf $src
  [si0 fix so1]
    | each { open $'scripts/($in).py' }
    | str join "\n"
    | fontforge -c $in $ttf
  woff2_compress $ttf
}

def mk_nerd [ttf: path, out: path] {
  nerd-font-patcher $ttf -out $out --careful -c
  nerd-font-patcher $ttf -out $out --careful -c -s
}

def mk_x [src: path, name: string, x = 1] {
  if $x <= 1 {
    mk_rest $src $name
  } else {
    let nm = $'($name)($x)x'
    bdfresize -f $x $src | save $'out/($nm).bdf'
    mk_rest $src $nm
  }
}

def mk_rest [src: path, name: string] {
  [si0 si1 fix so0]
    | each { open $'scripts/($in).py' }
    | str join "\n"
    | fontforge -c $in $src $'out/($name).' $name
  bdftopcf -o $'out/($name).pcf' $src
}
