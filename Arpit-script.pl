#using libraries. 
use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;
use File::Basename;
no warnings 'experimental::smartmatch';
my $directory = $ARGV[0];
my $createDir = $ARGV[1];
#by Defalut select file name.
my $filename ="report.txt";

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
# closing the directory 
   closedir(DIR);
   return @listofFiles;
}
# directory not defined them error message printed . 
if(not defined $directory){
  die("## Error - Directory not defined, add the directory and re-run the script.");
} else{
	my @indexFiles = "$directory/index.html";
   my @filesndDir = customReadDirectory($directory); # contains the directory and files 
# onlyFiles - all the files removing directories .
   my @onlyFiles = grep{$_ =~ m/\.[a-zA-Z]/ } @filesndDir ;  
   say(" ^^^^^^^^^^ The files are (@onlyFiles)");

# only directories that is downloads and Images.  
   my @subdiretory = grep{$_ !~ m/\.[a-zA-Z]/ } @filesndDir;
   say("The sub directory  are (@subdiretory)");
# now iterating each subdirectory and  push into an subdiretory array .
   my @data = repeatCustomReadDirectory(@subdiretory);
# Now read all the file and Parsh the file and find the link of the files.  
   my @rdata = readFile("@indexFiles");
   push @onlyFiles,@data; #push the files.

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
    my @create= makingDir($createDir);
    my $c = `cp -r ./@missingFiles @create`;
    say ("Files moved to: @create");
# This function open the file name.
    open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
    print $fh "Cleanup staistics for $directory:\n \n";
#This part check the how many GIF file is available.
    my $gif_nums = `ls @create/*.gif | grep -v ^1 |wc -l`;
#This part check the GIF file size. 
    my $gif_sizes = `stat --printf="%s" @create/*.gif `;
#This part check the how many HTML file is available. 
    my $html_nums = `ls @create/*.html | grep -v ^1 |wc -l`;
#This part check the HTML file size. 
    my $html_sizes = `stat --printf="%s" @create/*.html `;
#Total of files and size.
    my $total_nums = $gif_nums + $html_nums;
    my $total_sizes = $gif_sizes + $html_sizes;
    print $fh "GIF files: $gif_nums file(s) $gif_sizes bytes\n";
    print $fh "HTML files: $html_nums file(s) $html_sizes bytes\n";
    print $fh "Total: $total_nums file(s) $total_sizes bytes\n";
    close $fh;
  }
  if (defined $createDir){
    my @created= makeDir($createDir);
    my $w = `cp -r ./@missingFiles @created`;
    say ("Files moved to: @created");
    open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
    print $fh "Cleanup staistics for $directory:\n \n";
    my $gif_nums = `ls @created/*.gif | grep -v ^1 |wc -l`;
    my $gif_sizes = `stat --printf="%s" @created/*.gif `;
    my $html_nums = `ls @created/*.html | grep -v ^1 |wc -l`;
    my $html_sizes = `stat --printf="%s" @created/*.html `;
    my $total_nums = $gif_nums + $html_nums;
    my $total_sizes = $gif_sizes + $html_sizes;
    print $fh "GIF files: $gif_nums file(s) $gif_sizes bytes\n";
    print $fh "HTML files: $html_nums file(s) $html_sizes bytes\n";
    print $fh "Total: $total_nums file(s) $total_sizes bytes\n";
    close $fh;
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

#if the moving folder is not declare then it will select automatically and create directory.
sub makingDir{
  my $takingDir= "RubbishBin/$directory";
  my $createDir = `mkdir -vp $@ "$takingDir"`; 
  say ("By Default Folder taking: RubbishBin"); 
  return $takingDir;
}

# created dictionary if you select folder name to move your file into that folder.
sub makeDir{
	my $selectedDir = "$createDir/$directory";
	my $createdDir = `mkdir -p $selectedDir`;
	say("Folder created: $createDir");
	return $selectedDir;
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


# How to Run programme with given folder which you have to move files .
# perl clean.pl www Bin

# run programme without given folder which you have to move file.
# perl clean.pl www 
