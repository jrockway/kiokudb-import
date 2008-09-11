package KiokuDB::Import::Sink::Hash;
use Moose::Role;
use KiokuDB::Backend::Hash;

with 'KiokuDB::Import::Sink';

has '+connection' => (
    default => sub {
        my $self = shift;
        return KiokuDB->new(
            backend => KiokuDB::Backend::Hash->new(),
        );
    },
);

1;
