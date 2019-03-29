use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;
use File::Basename;
no warnings 'experimental::smartmatch';
my $directory = $ARGV[0];
my $createDir = $ARGV[1];
my @indexFiles = "$directory/index.html";

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

   closedir(DIR); # closing the directory 
   return @listofFiles;
}
# directory not defined them error message printed . 
if(not defined $directory){
  die("## Error - Directory not defined, add the directory and re-run the script.");
} else{
   my @filesndDir = customReadDirectory($directory); # contains the directory and files 
   # onlyFiles - all the files removing directories .
   my @onlyFiles = grep{$_ =~ m/\.[a-zA-Z]/ } @filesndDir ;  
   say(" ^^^^^^^^^^ The files are (@onlyFiles)");

   # only directories that is downloads and Images.  
   my @subdiretory = grep{$_ !~ m/\.[a-zA-Z]/ } @filesndDir;
   say("The sub directory  are (@subdiretory)");
   # now iterating each subdirectory and  push into an subdiretory array .
   my @data = repeatCustomReadDirectory(@subdiretory);
    # I have to create function like repeatCustomReadDirectory only for files.
   my @rdata = readFile("@indexFiles"); # need to change 
   push @onlyFiles,@data;

   foreach(@rdata){
     # list of all used links from index.html 
     say("used links in HTML Files need to kept as it is : $_");
   }

   foreach(@onlyFiles){
    # list of the all the files . 
    say (" total file in the current directory $directory: $_");
   }
   my @missingFiles = getMissingFiles(\@onlyFiles,\@rdata);
   foreach (@missingFiles){
    # unused links that needs to moved rubbish folder 
    say(" unused files: $_");
   }

   if (not defined $createDir){
    my $takingDir= "RubbishBin/$directory";
    my $createDir = `mkdir -vp $@ "$takingDir" && cp @missingFiles "$takingDir"`; 
    say ("By Default Folder taking: RubbishBin");
    my $total= print `stat --printf="%s\n" $takingDir | du -acb $takingDir/* > report.txt `;
  }
  if (defined $createDir){
    my $createdDir = `mkdir -p $createDir/$directory`;
    say("Folder created: $createDir");
    my $w = `cp -r ./@missingFiles $createDir/$directory`;
    my $total= print `du -acb $createDir/* > report.txt `;
    #my @move = moveFile(@missingFiles,@createDir)
  }

    # my @create= makeDir($createDir);
     #say "how @create";
     #my @move = moveFile(@missingFiles,@create);
    #my $total= print `stat --printf="%s\n" $directory | du -ah $directory/* > report.txt `;

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
    if(!($key ~~ @$usedFiles))
    {
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
  $createDir = $_[0]; # taking   input #test 
  my @a = ($createDir);
  return @a;
}

# readFile function that reads and returns src and href in an array
sub readFile{
  my $somefile = $_[0];
  my @links = ($somefile);
  my $p = HTML::TokeParser->new($somefile) || die "Can't open: $!";
  # configure its behaviour
  while (my $token = $p->get_tag("img","a")){
     my $currentlink = $token->[1]{href} || $token->[1]{src};
     my $finalLink= $directory."/".$currentlink ; 
     if($currentlink =~ /\.html$/){
         my @data = readFile($finalLink); # recursive Function that is called 
         push @links,@data;
     } else{
          push @links,$finalLink;
     }
  }
  return @links;
}


sub moveFile{
  my $fileName= $_;
  my $fileName2= $_;
  my $directoryName= $_[2];
  say $fileName;
  say $fileName2;
  my $path;
   foreach $path ($fileName,$fileName2){
    # unused links that needs to moved rubbish folder 
    (my $basename = $path) =~ s,.*/,,; #split comand used for geting last name.
    say(" unused files in movfile: $path -> $basename"); #If I used `cp $directory/$basename  ./RubishBin`. Then they only move craters2.html.
    say ("path is $path");
    my $b = `cp -r $path $directoryName`;
    #say ("driction name: $directoryName");
  }
  #say ("moveFile", $fileName,$directoryName);
}
