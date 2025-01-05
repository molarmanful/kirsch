def main [] {
  mkdir "out"
  bitsnpicas convertbitmap -f "ttf" -o "out/kirsch.ttf" -w 1 -h 1 "src/kirsch.bdf"

  gen_chars
}

def gen_chars [] {
  open "src/kirsch.bdf"
    | lines
    | find -r 'ENCODING [^-]'
    | each { split words | $in.1 }
}
