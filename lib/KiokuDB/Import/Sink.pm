package KiokuDB::Import::Sink;
use Moose::Role;

has 'connection' => (
    is         => 'ro',
    isa        => 'KiokuDB',
    lazy_build => 1,
);

sub _build_connection {
	my $self = shift;
	return KiokuDB->new(
		backend => $self->backend,
	);
}

has backend => (
    is         => 'ro',
    does       => 'KiokuDB::Backend',
    lazy_build => 1,
);

requires "_build_backend";

sub store {
    my ($self, $object) = @_;
    my $uid = $self->connection->store($object);
    $self->logger->info("Stored object as '$uid'");
};

1;
