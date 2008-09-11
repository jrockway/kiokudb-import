package KiokuDB::Import::Sink;
use Moose::Role;

use KiokuDB;

has 'connection' => (
    is         => 'ro',
    isa        => 'KiokuDB',
    lazy_build => 1,
);

has kiokudb_options => (
	isa => "HashRef",
	is  => "ro",
	default => sub { +{} },
);

sub _build_connection {
	my $self = shift;
	return KiokuDB->new(
		%{ $self->kiokudb_options },
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
