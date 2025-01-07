def main [--accents] {
  let src = 'src/kirsch.bdf'
  let codes = get_codes $src

  $codes | gen_chars $accents | save -f 'txt/chars.txt'
  $codes | gen_map $accents | save -f 'txt/map.txt'
  txt_correct
  gen_samples | save -f 'txt/sample.txt'
  (open 'txt/header.txt') + "\n" + (open "txt/sample.txt") | save -f 'txt/all.txt'

  gen_imgs $src
}

def get_codes [src: path]: nothing -> list<int> {
  open $src
  | lines
  | find -r '^\s*ENCODING\s+[^-]'
  | each { split words | get 1 | into int }
}

def txt_correct [] {
  ls 'txt'
  | where type == file
  | get 'name'
  | each {
      let f = $in
      open $f | str replace -m '\n$' '' | save -f $f
    }
}

def gen_chars [accents: bool]: list<int> -> string {
  $in
  | each { char -i $in }
  | if $accents { str replace -r '(\p{M})' ' $1' } else { }
  | chunks 48
  | each { str join ' ' }
  | str join "\n"
}

def gen_map [accents: bool]: list<int> -> string {
  $in
  | group-by { $in // 16 }
  | transpose k v
  | each {
      let k = $in.k | into int
      let v = $in.v
      let u = $k
        | fmt
        | get upperhex
        | str substring 2..
        | fill -w 4 -a 'r' -c '0'

      $k * 16
      | $in..($in + 15)
      | each { if $in in $v { char -i $in } else { ' ' } }
      | if $accents { str replace -r '(\p{M})' ' $1' } else { }
      | prepend $'U+($u)_ │'
      | str join ' '
    }
  | prepend [
      '          0 1 2 3 4 5 6 7 8 9 A B C D E F'
      '        ┌────────────────────────────────'
    ]
  | str join "\n"
}

def gen_samples []: nothing -> string {
  [prog eng multi scala clojure go svelte apl engalt pretty math box braille]
  | each { open $'txt/($in).txt' }
  | str join "\n"
}

def gen_imgs [$src] {
  let ttf = mktemp --suffix .ttf
  let tmpd = mktemp -d
  let tmp = $tmpd | path join 'tmp.ttf'
  bitsnpicas convertbitmap -f 'ttf' -o $tmp $src
  mv $tmp $ttf
  rm -rf tmpd

  print 'imgs...'
  ls 'txt'
  | where type == file
  | get 'name'
  | par-each {
      let stem = $in | path parse | get stem
      sh scripts/magick.sh $ttf 16 $in $stem '#1F0318' '#86CB92'
      print $' + ($stem)'
    }

  rm -f $ttf
}
