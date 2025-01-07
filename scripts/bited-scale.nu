def main [src: path, -x: int] {
  let bdf = open $src
  if $x < 2 { return $bdf }

  $bdf
    | lines -s
    | parse -r '^(?P<k>\w+)\s*(?P<v>.*)?\s*$'
    | enumerate
    | flatten
    | first 100 # FIXME: remove
    | scale $x
    | get 'res'
}

def scale [x: int]: table -> record {
  reduce -f { mode: 'x' res: $in } {|line, state| $state | transform $line }
}

def transform [line: record]: record -> record {
  let state = $in
  let mode = $state.mode

  match $mode {
    'x' => { $state | mode_x $line },
    'prop' => { $state | mode_prop $line },
    'bm' => { $state | mode_x $line },
  }
}

def mode_x [line: record]: record -> record {
  let state = $in
  let res = $state.res
  let k = $line.k
  let v = $line.v
  let i = $line.index

  match $k {
    STARTPROPERTIES => { $state | update mode 'prop' }
    BITMAP => { $state | update mode 'bm' }
    FONT => { $state } # FIXME
    SIZE | SWIDTH | DWIDTH  => {
      $state | update res { update $i { update v {
        split words | update 0 { into int | $in * 2 } | str join ' '
      } } }
    }
    FONTBOUNDINGBOX | BBX => { 
      $state | update res { update $i { update v {
        split words | each { into int | $in * 2 } | str join ' '
      } } }
    }
    _ => { $state }
  }
}

def mode_prop [line: record]: record -> record {
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
      $state | update res { update $i { update v {
        split words | update 0 { into int | $in * 2 } | str join ' '
      } } }
    }
    _ => { $state }
  }
}

def mode_bm [line: record]: record -> record {
  let state = $in
  let res = $state.res
  let k = $line.k
  let v = $line.v
  let i = $line.index

  match $k {
    ENDCHAR => { $state | update mode 'x' }
    # TODO
    _ => { $state }
  }
}

def xlfd [] {
  ## TODO
}
