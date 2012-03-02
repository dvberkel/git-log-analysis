#! /usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin";

use IO::Handle;

use Analysis::Util qw/analyseDir/;

foreach my $directory (@ARGV) {
    analyseDir($directory);
}
