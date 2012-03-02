#! /usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin";

use IO::Handle;

use Analysis::Util qw/analyse report/;

foreach my $directory (@ARGV) {
    if (usesGit($directory)) {
	process($directory)
    }
}

sub usesGit {
    my ($dir) = @_;
    return -e $dir && -d $dir && -d "$dir/.git";
}

sub process {
    my ($directory) = @_;
    pipe(READER, WRITER);
    WRITER->autoflush(1);
    if (my $pid = fork) {
	parentProcess($pid, *READER, *WRITER);
    } else {
	childProcess($pid, $directory, *READER, *WRITER);
    }
}

sub parentProcess {
    my ($pid, $READER, $WRITER) = @_;
    close $WRITER;
    while (my $line = <$READER>) {
	print $line;
    }
    close $READER;
    waitpid($pid, 0);

}

sub childProcess {
    my ($pid, $directory, $READER, $WRITER) = @_;
    die "can not fork: $!\n" unless defined $pid;
    close $READER;
    chdir $directory;
    open(GITLOG, "git log |");
    my %analysis = analyse(*GITLOG);
    print $WRITER report(\%analysis);
    close(GITLOG);
    close $WRITER;
    exit(0);	    
}
