package KiokuDB::Import::Sink::BDB;
use Moose::Role;
use MooseX::Types::Path::Class qw(Dir);

use KiokuDB;
use KiokuDB::Backend::BDB;

with 'KiokuDB::Import::Sink';

has 'storage' => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

sub _build_backend {
    my $self = shift;
	KiokuDB::Backend::BDB->new(
		dir => $self->storage,
	),
}

1;
