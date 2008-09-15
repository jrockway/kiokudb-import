package KiokuDB::Import::Sink::JSPON;
use Moose::Role;
use MooseX::Types::Path::Class qw(Dir);

use KiokuDB;
use KiokuDB::Backend::JSPON;

with 'KiokuDB::Import::Sink';

has 'storage' => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

sub _build_backend {
    my $self = shift;
	KiokuDB::Backend::JSPON->new(
		dir => $self->storage,
	),
}

1;
