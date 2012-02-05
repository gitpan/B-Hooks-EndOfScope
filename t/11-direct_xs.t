use strict;
use warnings;
use Test::More;
use Class::Load 'try_load_class';

BEGIN {
  try_load_class('B::Hooks::EndOfScope::XS')
    or plan skip_all => "XS functionality not available";

  B::Hooks::EndOfScope::XS->import();
}

BEGIN {
    ok(exists &on_scope_end, 'on_scope_end imported');
    is(prototype('on_scope_end'), '&', '.. and has the right prototype');
}

our $i;

sub foo {
    BEGIN {
        on_scope_end { $i = 42 };
    };

    is($i, 42, 'value still set at runtime');
}

BEGIN {
    is($i, 42, 'value set at compiletime')
}

foo();

done_testing;
