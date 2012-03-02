package Analysis::Util;

use strict;
use warnings;
use List::Util qw/min max/;

require Exporter;

our $VERSION = '1.0.0';

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/analyse report analyseDir/;

my $DEFAULT = "total commits";

sub analyse {
    my ($FH) = @_;
    my %analysis = ();
    while(my $line = <$FH>) {
	if ($line =~ m/\[([^\]]+)\]/) {
	    increment(\%analysis, $1);
	}
	if ($line =~ m/^commit/) {
	    increment(\%analysis, $DEFAULT);
	}
    }
    return %analysis;
}

sub increment {
    my ($analysis, $key) = @_;
    if (! exists $analysis->{$key}) {
	$analysis->{$key} = 0;
    }
    $analysis->{$key}++;
}

sub report {
    my $analysis = shift @_;
    my $result = "";
    my $maximum = max map {length($_)} (keys %$analysis);
    for my $key (sort keys %$analysis) {
	my $padding = padding(length($key), $maximum);
	my $value = $analysis->{$key};
	$result .= "$key$padding$value\n";
    }
    return $result;
}

sub padding {
    my ($length, $maximum) = @_;
    return "." x (5 + $maximum - $length);
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
