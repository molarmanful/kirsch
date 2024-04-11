f.os2_version = 4
f.os2_vendor = "BenP"
f.os2_panose = (2, 0, 6, 9, 0, 0, 0, 0, 0, 0)
f.os2_weight_width_slope_only = True
f.selection.all()
f.em = 2048
f.correctDirection()
f.removeOverlap()
for g in f:
    f[g].width = 768
    if f[g].unicode != -1:
        f[g].glyphname = nameFromUnicode(f[g].unicode, "AGL with PUA")
f.encoding = "UnicodeFull"
