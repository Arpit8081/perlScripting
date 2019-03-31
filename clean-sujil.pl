use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;
use File::Copy;
use File::Basename;
my $directory = $ARGV[0];
my $changeDir = $directory."-after";
my $rubbishBin = $ARGV[1];
my $indexFIle = $directory."/"."index.html";

# customReadDirectory {name of the directory} => or return the list of the files . 
sub customReadDirectory{

   my @listofFiles = ();
   my $directories = $_[0];
   # openDir = > open the directory
   opendir (DIR, $directories) or die $!;
    while (my $file = readdir(DIR)) {
      next unless (-d "$directories");
           if($file =~ /[a-zA-Z]/){ 
           # print "inside loop $file \n";
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
   # onlyFiles - all the files removing directories .
   my @onlyFiles = grep{$_ =~ m/\.[a-zA-Z]/ } @filesndDir ;  
   say(" ^^^^^^^^^^ The files are (@onlyFiles)");

   # only directories that is downloads and Images.  
   my @subdiretory = grep{$_ !~ m/\.[a-zA-Z]/ } @filesndDir;
   say("The sub directory  are @subdiretory");
   
    # creating the directory and making the changes accordiing to it . 
    makeDir($changeDir);
    makeDir($rubbishBin);
    renamingCurrentDirWithAfter(@subdiretory);
    #---------------------------------------------------------#
   # now iterating each subdirectory and  push into an subdiretory array .
   my @data = repeatCustomReadDirectory(@subdiretory);

    # I have to create function like repeatCustomReadDirectory only for files.
   my @rdata = readFile($indexFIle); # need to change 
   push @onlyFiles,@data;
   my @missingFiles = getMissingFiles(\@onlyFiles,\@rdata);
  
   foreach my $usefulLinks (@rdata){
     # list of all used links from index.html 
     say("used links in HTML Files need to kept as it is : $usefulLinks");
     my $saveOldusefulLinks = $usefulLinks;
     if($usefulLinks =~ s/^$directory/$changeDir/g){
          my $dirName = dirname($usefulLinks);
         `mv $saveOldusefulLinks  $dirName`;
     }
   }

   foreach(@onlyFiles){
    # list of the all the files . 
    say (" total file in the current directory $directory: $_");
   }
   
   foreach my $missingFile (@missingFiles){
    # unused links that needs to moved rubbish folder 
      say("$missingFile");
   }

   `mv $directory  $rubbishBin`
 

}

sub renamingCurrentDirWithAfter{
  my @dir = @_;
  foreach my $currentDir (@dir){
    say($currentDir,"before");
    if($currentDir =~ s/^$directory/$changeDir/g){
      say($currentDir);
      makeDir($currentDir);
    }
  }
}

sub getMissingFiles{
  my (@files) =@_;
  my $totalFiles = $files[0];
  my $usedFiles = $files[1];
  my @unusedFiles=();
# write logic for unsed files by @files array and @rdata array.
 foreach(@$totalFiles)
{
    my $key= $_;
    if(!($key ~~ @$usedFiles)){
        push(@unusedFiles, $key);
    }
}
return @unusedFiles;
}

# repeat array tasks for readDirectory
sub repeatCustomReadDirectory{
  my @dir = @_;
  my @onlyFiles =();
  foreach my $file (@dir) {
     my @file = customReadDirectory($file);
     push @onlyFiles, @file;
   }
  return @onlyFiles;
}


# creation of directory 
sub makeDir{
  my @argv= @_; # taking   input #test 
   `mkdir @argv`;
}

# readFile function that reads and returns src and href in an array
sub readFile{
  my $somefile = $_[0];
  my @links = ($somefile);
  #say("=====!  readFileCalled ====!!", @links);
  my $p = HTML::TokeParser->new($somefile) || die "Can't open: $!";
  # configure its behaviour
  while (my $token = $p->get_tag("img","a")){
     my $currentlink = $token->[1]{href} || $token->[1]{src};
     my $finalLink= $directory."/".$currentlink ; 
     if($currentlink =~ /\.html$/){
         #say("Reading the next html File is... ",$currentlink);
         my @data = readFile($finalLink); # recursive Function that is called 
         push @links,@data;
     } else{
          push @links,$finalLink;
     }
  }
  return @links;
}

