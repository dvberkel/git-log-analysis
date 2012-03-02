package Analysis::Util;

use strict;
use warnings;
use List::Util qw/min max/;

require Exporter;

our $VERSION = '1.0.0';

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/analyse report/;

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
