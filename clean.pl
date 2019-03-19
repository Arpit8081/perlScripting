use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;

my $directory = $ARGV[0];
my $indexFIle = "www/index.html";

# customReadDirectory {name of the directory} => or return the list of the files . 
sub customReadDirectory{

   my @listofFiles = ();
   my $directories = $_[0];
   # openDir = > open the directory
   opendir (DIR, $directories) or die $!;
    while (my $file = readdir(DIR)) {
      next unless (-d "$directories");
           if($file =~ /[a-zA-Z]/){ 
            print "inside loop $file \n";
            push @listofFiles,"$directories/$file"
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
   say("sub dir is @subdiretory");
   say("change \n");
   # now iterating each subdirectory and  push into an subdiretory array .
   my @data = repeatCustomReadDirectory(@subdiretory);
   push @onlyFiles,@data;

   foreach(@onlyFiles){
    print " file are : $_\n";
   }
   #makeDir("t2.txt");
   # readFile("www/craters1.html"); # works fine src and href 
  readFile("www/index.html");

}

# repeat array tasks 
sub repeatCustomReadDirectory{
  my @dir = @_;
  print (@dir);
  my @onlyFiles =();
  foreach my $file (@dir) {
     my @file = customReadDirectory($file);
     say("the file name is ====, @file");
     push @onlyFiles, @file;
   }
  return @onlyFiles;
}


# creation of directory 
sub makeDir{
  my ($argv)= $_; # taking   input #test 
   return `mkdir $argv`;
}

# readFile function that reads and returns src and href in an array
sub readFile{
  my $somefile = $_[0];
  my @links = ();
  my $p = HTML::TokeParser->new($somefile) || die "Can't open: $!";
  # configure its behaviour
  while (my $token = $p->get_tag("img","a")) {
     my $currentlink = $token->[1]{href} || $token->[1]{src};
     say("parsed links : $currentlink");
     push @links,$currentlink;
  }
  return @links;
}
