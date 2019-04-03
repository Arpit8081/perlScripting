use strict;
use warnings;
use 5.18.0;
use HTML::TokeParser;
use File::Basename;
no warnings 'experimental::smartmatch';
my $directory = $ARGV[0];
my $changeDir = $directory."-after";
my $createDir = $ARGV[1];
my $filename ="report.txt";

sub customReadDirectory{

   my @listofFiles = ();
   my $directories = $_[0];
   opendir (DIR, $directories) or die $!;
    while (my $file = readdir(DIR)) {
      next unless (-d "$directories");
           if($file =~ /[a-zA-Z]/){ 
            push @listofFiles,"$directories/$file"
           }     
    }
   closedir(DIR);
   return @listofFiles;
}
if(not defined $directory){
  die("## Error - Directory not defined, add the directory and re-run the script.");
} else{
	my @indexFiles = "$directory/index.html";
   my @filesndDir = customReadDirectory($directory);
   my @onlyFiles = grep{$_ =~ m/\.[a-zA-Z]/ } @filesndDir ;  
   say(" ^^^^^^^^^^ The files are (@onlyFiles)"); 
   my @subdiretory = grep{$_ !~ m/\.[a-zA-Z]/ } @filesndDir;
   say("The sub directory  are (@subdiretory)");
   makedDir($changeDir);
   renamingCurrentDirWithAfter(@subdiretory);
   my @data = repeatCustomReadDirectory(@subdiretory);
   my @rdata = readFile("@indexFiles");
   push @onlyFiles,@data;
   my @missingFiles = getMissingFiles(\@onlyFiles,\@rdata);
   foreach my $usefulLinks (@rdata){
     say("used links in HTML Files need to kept as it is : $usefulLinks");
     my $saveOldusefulLinks = $usefulLinks;
     if($usefulLinks =~ s/^$directory/$directory-after/g){
         say($usefulLinks);
          my $dirName = dirname($usefulLinks);
         `mv -n $saveOldusefulLinks  $dirName`;
         say(" $saveOldusefulLinks  $dirName");
     }
   }

   foreach(@onlyFiles){

    say (" total file in the current directory $directory: $_");
   }
   if (not defined $createDir){
    my @create= makingDir($createDir);
    foreach my $missingFile (@missingFiles){
    say(" unused files: $missingFile");
    }
    `mv -n $directory  @create`;
    say ("Files moved to: @create");
    open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
    print $fh "Cleanup staistics for $directory:\n \n";
    my $gif_nums = `find @create -type f -name *.gif -o -name *.jpg -o -name *.bmp| wc -l`; 
    my $gif_sizes = `find @create -type f -name *.gif -printf "%s\t"`;
    my $html_nums = `find @create -type f -name *.html | wc -l`;
    my $html_sizes = `find @create -type f -name *.html -printf "%s\t" `;
    my $total_nums = $gif_nums + $html_nums;
    my $total_sizes = $gif_sizes + $html_sizes;
    print $fh "GIF Files: $gif_nums file(s) $gif_sizes bytes\n";
    print $fh "HTML Files: $html_nums file(s) $html_sizes bytes\n";
    print $fh "Total: $total_nums file(s) $total_sizes bytes\n";
    close $fh;
  }
  if (defined $createDir){

     my @created= makeDir($createDir);
    foreach my $missingFile (@missingFiles){
    say(" unused files: $missingFile");
    }
    `mv -n $directory  @created`;
    say ("Files moved to: @created");
    open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
    print $fh "Cleanup staistics for $directory:\n \n";
    my $gif_nums = `find @created -type f -name *.gif -o -name *.jpg -o -name *.bmp| wc -l`;
    my $gif_sizes = `find @created -type f -name *.gif -printf "%s\t"`;
    my $html_nums = `find @created -type f -name *.html | wc -l`;
    my $html_sizes = `find @created -type f -name *.html -printf "%s\t" `;
    my $total_nums = $gif_nums + $html_nums;
    my $total_sizes = $gif_sizes + $html_sizes;
    print $fh "GIF files: $gif_nums file(s) $gif_sizes bytes\n";
    print $fh "HTML files: $html_nums file(s) $html_sizes bytes\n";
    print $fh "Total: $total_nums file(s) $total_sizes bytes\n";
    close $fh;
  }
}

sub renamingCurrentDirWithAfter{
  my @dir = @_;
  foreach my $currentDir (@dir){
    say($currentDir,"before");
    if($currentDir =~ s/^$directory/$directory-after/g){
      say($currentDir);
      makedDir($currentDir);
    }
  }
}
sub getMissingFiles{
  my (@files) =@_;
  my $totalFiles = $files[0];
  my $usedFiles = $files[1];
  my @unusedFiles=();
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

sub repeatCustomReadDirectory{
  my @dir = @_;
  my @onlyFiles =();
  foreach my $file (@dir) {
     my @file = customReadDirectory($file);
     push @onlyFiles, @file;
   }
  return @onlyFiles;
}
sub makedDir{
  my @argv= @_;
  say(@argv, "called");
   `mkdir -p @argv`;
}

sub makingDir{
  my $takingDir= "RubbishBin";
  foreach ($takingDir){
    if (-e $filename) {
    `rm -rf $filename`;
    say ("What is thisssssssssssssssssssssssssss");
  } 
  my $createDirn = `mkdir -p $@ "$takingDir"`; 
  say ("By Default Folder taking: RubbishBin"); 
  }
  return $takingDir;
}


sub makeDir{
	my @selectedDir = @_;
	my $createdDir = `mkdir -p @selectedDir`;
	say("Folder created: $createDir");
	return @selectedDir;
}

sub readFile{
	my $somefile = $_[0];
	my @links = ($somefile);
	my $p = HTML::TokeParser->new($somefile) || die "Can't open: $!";
  	while (my $token = $p->get_tag("img","a")){
     	my $currentlink = $token->[1]{href} || $token->[1]{src};
     	my $finalLink= $directory."/".$currentlink ; 
     	if($currentlink =~ /\.html$/){
        	my @data = readFile($finalLink); 
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
