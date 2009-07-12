
BEGIN {
  print "(** Values of physical constants *)\n"
  if (ARGV[1] == "--mli") {
    MLI=1
    delete ARGV[1]
  }
}

/^#define GSL_CONST_/ {
  if (MLI)
    printf "val %s : float\n", tolower(substr($2,11))
  else
    printf "let %s = %s\n", tolower(substr($2,11)), substr($3,2,length($3)-2)
}
  
