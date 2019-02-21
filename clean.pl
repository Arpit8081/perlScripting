use strict;
use warnings;

my($path,$regexExpression) = @ARGV;
my $fileName = "data.txt";


if(not defined $path){
	die "File directory not given, please  try again \n"
}

print "added file ";

if (not defined $regexExpression) {
  # if regular expression not added or with the script it automatically consider regular expression as *		
  $regexExpression="*";
  print "--Taking default Regular Expression. \n"
}

if (defined $regexExpression) {
  print "The regular Expression : $regexExpression \n";
  my $directorypathx= `pwd`;
  print `find '$path' -name '$regexExpression' -printf " %kKb %p\n" | grep -Po '(?<=href=")[^"]*' $path/*.html | sort -h -r > $fileName `;

 }