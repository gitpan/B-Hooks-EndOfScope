use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.06

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/B/Hooks/EndOfScope.pm',
    'lib/B/Hooks/EndOfScope/PP.pm',
    'lib/B/Hooks/EndOfScope/PP/FieldHash.pm',
    'lib/B/Hooks/EndOfScope/PP/HintHash.pm',
    'lib/B/Hooks/EndOfScope/XS.pm'
);

notabs_ok($_) foreach @files;
done_testing;
