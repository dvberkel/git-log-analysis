#! /usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin";

use IO::Handle;

use Analysis::Util qw/analyse report/;

foreach my $directory (@ARGV) {
    if (usesGit($directory)) {
	pipe(READER, WRITER);
	WRITER->autoflush(1);
	if (my $pid = fork) {
	    close WRITER;
	    while (my $line = <READER>) {
		print $line;
	    }
	    close READER;
	    waitpid($pid, 0);
	} else {
	    die "can not fork: $!\n" unless defined $pid;
	    close READER;
	    print WRITER "Sending: $directory\n";
	    print WRITER "Finished sending\n";
	    close WRITER;
	    exit(0);	    
	}
    }
}

sub usesGit {
    my ($dir) = @_;
    return -e $dir && -d $dir && -d "$dir/.git";
}
