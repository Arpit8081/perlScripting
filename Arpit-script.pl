use warnings;
use strict;
use feature 'say';

use File::Find::Rule;
use HTML::TreeBuilder;

my ($dir, $source_file) = @ARGV;    
die "Usage: $0 dir-name file-name\n" if not $dir or not $source_file;

my @files = File::Find::Rule->file->in($dir);
#say for @files;

foreach my $file (@files) {
    next if $file eq $source_file;  # not the file itself!
    say "Processing $file...";
    my $tree = HTML::TreeBuilder->new_from_file($source_file);

    my $esc_file = quotemeta $file;    
    my @in_href    = $tree->look_down(                'href', qr/$esc_file/ );
    my @in_img_src = $tree->look_down( _tag => 'img', 'src',  qr/$esc_file/ );

    if (@in_href == 0 and @in_img_src == 0) {
        say "\tthis file is not used in 'href' or 'img-src' in $source_file";
        # To delete it uncomment the next line -- after all is fully tested
        #unlink $file or warn "Can't unlink $file: $!";
    }
}

# how to run programme
# go to inside www directory and run the programme like this: perl script.html . index.html
# perl scrpit.html . creater1.html