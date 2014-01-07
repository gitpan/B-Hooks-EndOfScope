# NAME

B::Hooks::EndOfScope - Execute code after a scope finished compilation

# VERSION

version 0.13

# SYNOPSIS

    on_scope_end { ... };

# DESCRIPTION

This module allows you to execute code when perl finished compiling the
surrounding scope.

# FUNCTIONS

## on\_scope\_end

    on_scope_end { ... };

    on_scope_end $code;

Registers `$code` to be executed after the surrounding scope has been
compiled.

This is exported by default. See [Sub::Exporter](https://metacpan.org/pod/Sub::Exporter) on how to customize it.

# PURE-PERL MODE CAVEAT

While [Variable::Magic](https://metacpan.org/pod/Variable::Magic) has access to some very dark sorcery to make it
possible to throw an exception from within a callback, the pure-perl
implementation does not have access to these hacks. Therefore, what
would have been a compile-time exception is instead converted to a
warning, and your execution will continue as if the exception never
happened.

To explicitly request an XS (or PP) implementation one has two choices. Either
to import from the desired implementation explicitly:

    use B::Hooks::EndOfScope::XS
      or
    use B::Hooks::EndOfScope::PP

or by setting `$ENV{B_HOOKS_ENDOFSCOPE_IMPLEMENTATION}` to either `XS` or
`PP`.

# SEE ALSO

[Sub::Exporter](https://metacpan.org/pod/Sub::Exporter)

[Variable::Magic](https://metacpan.org/pod/Variable::Magic)

# AUTHORS

- Florian Ragwitz <rafl@debian.org>
- Peter Rabbitson <ribasushi@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# CONTRIBUTORS

- Karen Etheridge <ether@cpan.org>
- Tomas Doran <bobtfish@bobtfish.net>
