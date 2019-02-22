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
  my ($listofFileNames) = findFilesinDir($path);  # List of the files in a Directory.
  print $listofFileNames; 
 }

# findFilesinDir :: -> A function that is used to find the  files in the directory and return the list of the array.
 sub findFilesinDir{
 	print "inside subroutines";
 	my($path) = @_;
 	my $fileNames =`find '$path' -name '$regexExpression' | sort -h -r ` ;
 	return $fileNames; 
 }