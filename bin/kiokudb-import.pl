#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use KiokuDB::Import::Script::ImportYAMLDirectory;
KiokuDB::Import::Script::ImportYAMLDirectory->new_with_options->run;
