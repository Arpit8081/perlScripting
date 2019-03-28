use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;
use File::Basename;
#no warnings 'experimental::smartmatch';
my $directory = $ARGV[0];
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

   my @create= makeDir(@missingFiles);
   my @move = moveFile(@missingFiles,@create);
   #}
   #makeDir("data.txt");
   #readFile("www/craters1.html"); # works fine src and href 
   #readFile("www/index.html");
   #my @readData = readFile(@rdata, @data);
   #say(@readData);1
   my $total= print `find '$directory'  -printf  "%sB %p\n" | du -ch $directory/* > report.txt `;

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
  my $createDir = $ARGV[1]; # taking   input #test 
  my $a = `mkdir -p $createDir`;
  return $a;
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
  my $fileName= $_[0];
  my $fileName2= $_[1];
  my $directoryName= $_[2];
  say $fileName;
  say $fileName2;
  say $directoryName;
   #foreach my $path ($fileName,$directoryName){
    # unused links that needs to moved rubbish folder 
    #(my $basename = $path) =~ s,.*/,,; #split comand used for geting last name.
    #say(" unused files in movfile: $path -> $basename");
    #my $b = `cp -r $path  `; #If I used `cp $directory/$basename  ./RubishBin`. Then they only move craters2.html.
  #}

  #say ("moveFile", $fileName,$directoryName);

}
