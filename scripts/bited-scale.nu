use std repeat

def main [src: path, -x: int] {
  let bdf = open $src
  if $x < 2 { return $bdf }

  $bdf
  | lines -s
  | parse -r '^(?P<k>\w+)\s*(?P<v>.*)?\s*$'
  | enumerate | flatten
  | scale $x
  | get 'res'
  | each { $in.k + ' ' + $in.v }
  | str join "\n"
}

def scale [x: int]: table -> record {
  reduce -f { mode: 'x', res: $in } {|line, state| $state | transform -x $x $line }
}

def transform [line: record, -x: int]: record -> record {
  let state = $in
  let mode = $state.mode

  match $mode {
    'x' => { $state | mode_x -x $x $line },
    'prop' => { $state | mode_prop -x $x $line },
    'bm' => { $state | mode_bm -x $x $line },
  }
}

def mode_x [line: record, -x: int]: record -> record {
  let state = $in
  let res = $state.res
  let k = $line.k
  let v = $line.v
  let i = $line.index

  match $k {
    STARTPROPERTIES => { $state | update mode 'prop' }
    BITMAP => { $state | update mode 'bm' }
    FONT => {
      $state | upval $i {
        let xlfd = split column '-' | get 0 | values
        [7 8 12]
        | reduce -f $xlfd {|i, acc|
            $acc | update $i { into int -s | $in * $x }
          }
        | str join '-'
      }
    }
    SIZE | SWIDTH | DWIDTH  => {
      $state | upval $i {
        split words
        | update 0 { into int -s | $in * $x }
        | str join ' '
      }
    }
    FONTBOUNDINGBOX | BBX => { 
      $state | upval $i {
        split words
        | each { into int -s | $in * $x }
        | str join ' '
      }
    }
    _ => { $state }
  }
}

def mode_prop [line: record, -x: int]: record -> record {
  let state = $in
  let res = $state.res
  let k = $line.k
  let v = $line.v
  let i = $line.index

  match $k {
    ENDPROPERTIES => { $state | update mode 'x' }
    PIXEL_SIZE | POINT_SIZE | AVERAGE_WIDTH
    | FONT_ASCENT | FONT_DESCENT | CAP_HEIGHT | X_HEIGHT
    | BITED_DWIDTH | BITED_EDITOR_GRID_SIZE => {
      $state | upval $i {
        split words
        | update 0 { into int -s | $in * $x }
        | str join ' '
      }
    }
    _ => { $state }
  }
}

def mode_bm [line: record, -x: int]: record -> record {
  let state = $in
  let res = $state.res
  let k = $line.k
  let v = $line.v
  let i = $line.index

  match $k {
    ENDCHAR => { $state | update mode 'x' }
    _ => {
      $state | upkey $i {
        split chars
        | each {
            into int -r 16
            | fmt | get 'binary' | str substring 2..
            | split chars
            | each { repeat $x | str join }
            | str join
            | into int -r 2
            | fmt | get 'upperhex' | str substring 2..
            | fill -w $x -a 'r' -c '0'
          }
        | str join
        | repeat 2
        | str join "\n"
      }
    }
  }
}

def upkey [i: int, f: any]: record -> record {
  update res { update $i { update k $f } }
}

def upval [i: int, f: any]: record -> record {
  update res { update $i { update v $f } }
}
