use strict;
use warnings;
use 5.008001;

use ExtUtils::MakeMaker;

my $mymeta_works = eval { ExtUtils::MakeMaker->VERSION('6.5707'); 1 };
my $mymeta = $mymeta_works || eval { ExtUtils::MakeMaker->VERSION('6.5702'); 1 };

my %BUILD_DEPS = (
    'Test::More' => '0.88'
);

my %RUN_DEPS = (
    'Class::Load' => '0.13',
    'Sub::Exporter' => '0.981'
);

my %OPT_RUN_DEPS = (can_cc() ? (
  'Variable::Magic' => '0.34', # when changing, also change it in B::Hooks::EndOfScope::XS

  # make sure we smoke the pure-perl version fallback
  is_smoker() ? ( 'Devel::Hide' => '0.0007' ) : (),
) : () );

my %WriteMakefileArgs = (
  "NAME" => "B::Hooks::EndOfScope",
  "ABSTRACT" => "Execute code after a scope finished compilation",
  "AUTHOR" => "Florian Ragwitz <rafl\@debian.org>",
  "DISTNAME" => "B-Hooks-EndOfScope",
  "LICENSE" => "perl",
  "VERSION_FROM" => 'lib/B/Hooks/EndOfScope.pm',
  "test" => {
    "TESTS" => "t/*.t"
  },

  "PREREQ_PM" => {
    %RUN_DEPS, %OPT_RUN_DEPS,
    $mymeta_works ? () : (%BUILD_DEPS),
  },

  $mymeta_works
    ? ( # BUILD_REQUIRES makes MYMETA right, requires stops META being wrong
      "BUILD_REQUIRES" => \%BUILD_DEPS,
      "META_ADD" => {
        requires => \%RUN_DEPS,
      },
    )
    : ( # META_ADD both to get META right - only Makefile written
      "META_ADD" => {
        requires => \%RUN_DEPS,
        build_requires => \%BUILD_DEPS,
      },
    )
  ,

  ($mymeta and !$mymeta_works) ? ( 'NO_MYMETA' => 1 ) : (),
);


unless ( eval { ExtUtils::MakeMaker->VERSION('6.56') } ) {
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
  unless eval { ExtUtils::MakeMaker->VERSION('6.52') };

WriteMakefile(%WriteMakefileArgs);


# can we locate a (the) C compiler
sub can_cc {
  my @chunks = split(/ /, $Config::Config{cc}) or return;

  # $Config{cc} may contain args; try to find out the program part
  while (@chunks) {
    return can_run("@chunks") || (pop(@chunks), next);
  }

  return;
}

# check if we can run some command
sub can_run {
  my ($cmd) = @_;

  return $cmd if -x $cmd;
  if (my $found_cmd = MM->maybe_command($cmd)) {
    return $found_cmd;
  }

  for my $dir ((split /$Config::Config{path_sep}/, $ENV{PATH}), '.') {
    next if $dir eq '';
    my $abs = File::Spec->catfile($dir, $cmd);
    return $abs if (-x $abs or $abs = MM->maybe_command($abs));
  }

  return;
}

# is this a smoker?
sub is_smoker {
  return ( $ENV{AUTOMATED_TESTING} && ! $ENV{PERL5_CPANM_IS_RUNNING} && ! $ENV{RELEASE_TESTING} )
}
