#!/usr/bin/perl
    use strict;
    use warnings;
    use 5.18.0;
    my $directory = scalar $ARGV[0];
    my @myNames = ();
    opendir (DIR, $directory) or die $!;

    while (my $file = readdir(DIR)) {
    	next unless (-d "$directory");
    	   # defined($directory)&& ($directory =~ m/.html$/)
    	     say("DIR ++++++++  $directory"); 
    	     say("this is a  $file");

    	     if($file =~ /\.[a-zA-Z]/){
    	     	print "inside loop \n";
    	     	push @myNames,$file
    	     }		 
    }

   closedir(DIR);
my @index = grep {$_ =~ /index/} @myNames ;
    say("\n");
    say("\n");
    say(@myNames);
    say("\n");
    say("the is index is @index");

my %hash = (one => "uno",two=> "dos",dir => [("3","4")]);

while (my($k,$v)=each %hash){
	say "$k  ->  $v";
}

