{
  name,
  cfg ? "",
  P,

  writeShellApplication,
  ...
}:

writeShellApplication {
  inherit name;
  text = "${P.bited-img}/bin/bited-img ${cfg}";
}
