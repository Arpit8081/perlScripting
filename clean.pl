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
  my ($listofLinks) = readallHrefInaFile();
  print $listofLinks; 
 }

# print `find '$path' -name '$regexExpression' -printf " %kKb %p\n" | grep -Po '(?<=href=")[^"]*' $path/*.html | sort -h -r > $fileName `;


# findFilesinDir :: -> A function that is used to find the  files in the directory and return the list of the array.
 sub findFilesinDir{
 	print "inside subroutines \n", $path;
 	print "inside subroutines ", $path,"\n";
 	my($pathName) = @_;
 	my $fileNames =`find '$pathName' -name '$regexExpression' | sort -h -r ` ;
 	return $fileNames; 
 }


sub readallHrefInaFile{
	#my ($currentFile) = '';
  my $getAllLinks = ` grep -Eo "<a .*href=.*>" $path*.html| uniq` ;
  print $getAllLinks ; 
    #return $getAllLinks;
}
 # run the program 
 # perl clean.pl www

