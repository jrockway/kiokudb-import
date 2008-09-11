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

has '+connection' => (
    default => sub {
        my $self = shift;
        return KiokuDB->new(
            backend => KiokuDB::Backend::JSPON->new(
                dir => $self->storage,
            ),
        );
    },
);

1;
