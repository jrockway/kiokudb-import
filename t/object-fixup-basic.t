use strict;
use warnings;
use Test::More tests => 14;

use Scalar::Util qw(refaddr weaken);
use YAML;

use KiokuDB::Import::FixupObject qw(fixup_object);

# convince Perl these classes are loaded
{ package Foo; sub foo {}; package Bar; sub bar {} }

my $non_moose_obj = Load(<<YAML);
--- &1 !!perl/hash:Foo
oh: "hai"
bar: !!perl/hash:Bar
  name: Hello
self: *1
YAML

my $fixed_non_moose_obj = fixup_object $non_moose_obj;
isa_ok $fixed_non_moose_obj, 'Foo';
isa_ok $fixed_non_moose_obj->{self}, 'Foo';
isa_ok $fixed_non_moose_obj->{bar}, 'Bar';
is $fixed_non_moose_obj->{oh}, 'hai';
is $fixed_non_moose_obj->{bar}{name}, 'Hello';

is refaddr($fixed_non_moose_obj), refaddr($fixed_non_moose_obj->{self}),
  'circular ref preserved';

{
	package A::Nonmoose::Class; # not to be confused with an anonymous class!
	use base qw(Class::Accessor);

	__PACKAGE__->mk_accessors(qw(name));

	package A::Moose::Class;
	use Moose;

	has string => ( is => 'ro', isa => 'Str', required => 1);
	has other  => ( is => 'ro', isa => 'A::Nonmoose::Class');
        has self   => ( is => 'ro', isa => 'A::Moose::Class', weak_ref => 1);
        has moose  => ( is => 'ro', isa => 'Str', required => 1, default => 'hi' );
}

my $moose_obj = bless {
    string => 'test',
    other  => A::Nonmoose::Class->new( { name => 'Yuval' } ),
} => 'A::Moose::Class';

$moose_obj->{self} = $moose_obj;
weaken( $moose_obj->{self} );

isnt $moose_obj->{moose}, 'hi';

my $fixed_moose_obj = fixup_object $moose_obj;

isa_ok $fixed_moose_obj, 'A::Moose::Class';
isa_ok $fixed_moose_obj->other, 'A::Nonmoose::Class';
isa_ok $fixed_moose_obj->self, 'A::Moose::Class';

is $fixed_moose_obj->string, 'test';
is $fixed_moose_obj->other->name, 'Yuval';
is $fixed_moose_obj->moose, 'hi', '"default" worked';
is refaddr($fixed_moose_obj), refaddr($fixed_moose_obj->{self}),
  'circular ref preserved';
