package KiokuDB::Import::Sink::JSPON;
use Moose::Role;
use MooseX::Types::Path::Class qw(Dir);

use KiokuDB;
use KiokuDB::Backend::JSPON;

has 'storage' => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

has 'connection' => (
    is      => 'ro',
    isa     => 'KiokuDB',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return KiokuDB->new(
            backend => KiokuDB::Backend::JSPON->new(
                dir => $self->storage,
            ),
        );
    },
);

override store => sub {
    my ($self, $object) = @_;
    my $uid = $self->connection->store($object);
    $self->logger->info("Stored object as '$uid'");
};

1;
