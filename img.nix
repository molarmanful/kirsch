{
  name,
  cfg ? "",

  bited-img,

  writeShellApplication,
  ...
}:

writeShellApplication {
  inherit name;
  text = "${bited-img}/bin/bited-img ${cfg}";
}
