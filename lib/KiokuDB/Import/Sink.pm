package KiokuDB::Import::Sink;
use Moose::Role;

excludes 'KiokuDB::Import::Sink'; # An emo role?

has 'connection' => (
    is      => 'ro',
    isa     => 'KiokuDB',
    lazy    => 1,
);

sub store {
    my ($self, $object) = @_;
    my $uid = $self->connection->store($object);
    $self->logger->info("Stored object as '$uid'");
};

1;
