#!/usr/bin/perl
    use strict;
    use warnings;
    use 5.18.0;

    my $directory = 'www';
    my @myNames = ();
    opendir (DIR, $directory) or die $!;

    while (my $file = readdir(DIR)) {
    	next unless (-d "$directory");
    	   # defined($directory)&& ($directory =~ m/.html$/)
    	     say("DIR ++++++++  $directory"); 
    	     say("this is a  $file");

    	     if($file =~ /html/){
    	     	print "inside loop \n";
    	     	push @myNames,$file
    	     }
   
    		 
       
    }

    closedir(DIR);

   

my %hash = (one => "uno",two=> "dos",dir => [("3","4")]);

while (my($k,$v)=each %hash){
	say "$k  ->  $v";
}