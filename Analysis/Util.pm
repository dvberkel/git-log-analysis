package Analysis::Util;

use strict;
use warnings;
use List::Util qw/min max/;

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
    my $maximum = max map {length($_)} (keys %$analysis);
    for my $key (keys %$analysis) {
	my $padding = padding(length($key), $maximum);
	my $value = $analysis->{$key};
	print "$key$padding$value\n";
    }
}

sub padding {
    my ($length, $maximum) = @_;
    return "." x (5 + $maximum - $length);
}
