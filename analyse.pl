#! /usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin";

use Analysis::Util qw/analyse report/;

my %analysis = analyse(*STDIN);
print report(\%analysis)
