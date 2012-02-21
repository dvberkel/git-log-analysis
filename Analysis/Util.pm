package Analysis::Util;

use strict;
use warnings;

require Exporter;

our $VERSION = '1.0.0';

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/analyse report/;

my $DEFAULT = "default";

sub analyse {
    my %analysis = ();
    while(my $line = <>) {
	my $key = $DEFAULT;
	if ($line =~ m/\[([^\]]+)\]/) {
	    $key = $1;
	}
	increment(\%analysis, $key);
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
    for my $key (keys %$analysis) {
	my $value = $analysis->{$key};
	print "$key : $value\n";
    }
}
