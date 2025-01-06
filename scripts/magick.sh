ttf="$1"
fsz="$2"
txt="$3"
out="$4"
bg="$5"
fg="$6"

magick \
  -background "$bg" -fill "$fg" \
  -font "$ttf" -pointsize "$fsz" +antialias \
  label:@$txt \
  -bordercolor "$bg" -border "$fsz" \
  img/"$out".png
