package Analysis::Util;

use strict;
use warnings;

require Exporter;

our $VERSION = '1.0.0';

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/analyse report/;

sub analyse {
    my %analysis = ();
    while(my $line = <>) {
	if ($line =~ m/\[([^\]]+)\]/) {
	    if (! exists $analysis{$1}) {
		$analysis{$1} = 0;
	    }
	    $analysis{$1}++;
	}
    }
    return %analysis;
}

sub report {
    my $analysis = shift @_;
    for my $key (keys %$analysis) {
	my $value = $analysis->{$key};
	print "$key : $value\n";
    }
}
