#! /usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin";

use IO::Handle;

use Analysis::Util qw/analyse report/;

foreach my $directory (@ARGV) {
    analyseDir($directory);
}

sub analyseDir {
    my ($directory) = @_;
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
	parentProcess($pid, $directory, *READER, *WRITER);
    } else {
	childProcess($pid, $directory, *READER, *WRITER);
    }
}

sub parentProcess {
    my ($pid, $directory, $READER, $WRITER) = @_;
    close $WRITER;
    print "$directory\n";
    print "=" x length($directory), "\n";
    while (my $line = <$READER>) {
	print $line;
    }
    close $READER;
    print "\n";
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
