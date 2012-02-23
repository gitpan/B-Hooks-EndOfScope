
use strict;
use warnings;

use 5.008000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Execute code after a scope finished compilation",
  "AUTHOR" => "Florian Ragwitz <rafl\@debian.org>",
  "BUILD_REQUIRES" => {
    "Test::More" => "0.89"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "B-Hooks-EndOfScope",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "B::Hooks::EndOfScope",
  "PREREQ_PM" => {
    "Sub::Exporter" => 0,
    "Variable::Magic" => "0.48",
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.11",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



