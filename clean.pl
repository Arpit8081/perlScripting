use strict;
use warnings;
use 5.18.0;

my $directory = $ARGV[0];


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
   makeDir("test");
}


# creation of directory 
sub makeDir{
  my ($argv)= @_; # taking input #test 
   return `mkdir $argv`;
}