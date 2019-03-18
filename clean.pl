use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;

my $directory = $ARGV[0];
my $indexFIle = "www/index.html";

# customReadDirectory {name of the directory} => or return the list of the files . 
sub customReadDirectory{

   my @listofFiles = ();

   # openDir = > open the directory
   opendir (DIR, $directory) or die $!;
    while (my $file = readdir(DIR)) {
      next unless (-d "$directory");
           if($file =~ /[a-zA-Z]/){ 
            print "inside loop \n";
            push @listofFiles,$file
           }     
    }

   closedir(DIR); # closing the direcotory 
   return @listofFiles;
}
# directory not defined them error message printed . 
if(not defined $directory){
  die("## Error - Directory not defined, add the directory and re-run the script.");
} else{
   my @filesndDir = customReadDirectory($directory); # contains the direcory and files 
   say("at files ",@filesndDir);
   # onlyFiles - all the files removing directories .
   my @onlyFiles = grep{$_ =~ m/\.[a-zA-Z]/ } @filesndDir ;  
   say(@onlyFiles);
   # only directory  
   my @subdiretory = grep{$_ !~ m/\.[a-zA-Z]/ } @filesndDir;
   say(@subdiretory);

   #makeDir("t2.txt");
  # readFile("www/craters1.html"); # works fine src and href 
  readFile("www/index.html");

}


# creation of directory 
sub makeDir{
  my ($argv)= @_; # taking   input #test 
   return `mkdir $argv`;
}

# readFile function that reads and returns src and href in an array
sub readFile{
  my $somefile = @_[0];
  say("ssssssssssss $somefile");
  my @links = ();
  my $p = HTML::TokeParser->new($somefile) || die "Can't open: $!";
  # configure its behaviour
  while (my $token = $p->get_tag("img","a")) {
     my $currentlink = $token->[1]{href} || $token->[1]{src};
     say($currentlink);
     push @links,$currentlink;
  }
  return @links;
}
