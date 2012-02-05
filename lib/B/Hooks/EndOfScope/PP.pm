package B::Hooks::EndOfScope::PP;
BEGIN {
  $B::Hooks::EndOfScope::PP::AUTHORITY = 'cpan:FLORA';
}
{
  $B::Hooks::EndOfScope::PP::VERSION = '0.09_01';
}
# ABSTRACT: Execute code after a scope finished compilation - PP implementation

use warnings;
use strict;

use Carp;

use constant PERL_VERSION => "$]";

BEGIN {
  if (PERL_VERSION =~ /5.009/) {
    die "B::Hooks::EndOfScope does not operate on perl 5.9.X in pure-perl mode by design\n"
  }
  elsif (PERL_VERSION < '5.010') {
    require B::Hooks::EndOfScope::PP::HintHash;
    *on_scope_end = \&B::Hooks::EndOfScope::PP::HintHash::on_scope_end;
  }
  else {
    require B::Hooks::EndOfScope::PP::FieldHash;
    *on_scope_end = \&B::Hooks::EndOfScope::PP::FieldHash::on_scope_end;
  }
}

use Sub::Exporter -setup => {
  exports => ['on_scope_end'],
  groups  => { default => ['on_scope_end'] },
};

sub __invoke_callback {
  do {
    local $@ if PERL_VERSION < '5.013002';
    eval { $_[0]->(); 1 };
  } or do {
    my $err = $@;
    require Carp;
    Carp::cluck( (join ' ',
      'A scope-end callback raised an exception, which can not be propagated when',
      'B::Hooks::EndOfScope operates in pure-perl mode. Your program will CONTINUE',
      'EXECUTION AS IF NOTHING HAPPENED AFTER THIS WARNING. Below is the complete',
      'exception text, followed by a stack-trace of the callback execution:',
    ) . "\n\n$err\n\r" );

    sleep 3 if -t *STDIN;  # maybe a bad idea...?

    $@ = $err;  # not that it matters much
  };
}


1;

__END__
=pod

=encoding utf-8

=head1 NAME

B::Hooks::EndOfScope::PP - Execute code after a scope finished compilation - PP implementation

=head1 DESCRIPTION

This is the pure-perl implementation of L<B::Hooks::EndOfScope> based only on
modules available as part of the perl core. Its leaner sibling
L<B::Hooks::EndOfScope::XS> will be automatically preferred if all
dependencies are available and C<$ENV{B_HOOKS_ENDOFSCOPE_USE_XS}> is not set
to a false value.

=head1 FUNCTIONS

=head2 on_scope_end

    on_scope_end { ... };

    on_scope_end $code;

Registers C<$code> to be executed after the surrounding scope has been
compiled.

This is exported by default. See L<Sub::Exporter> on how to customize it.

=head1 AUTHOR

Florian Ragwitz <rafl@debian.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

