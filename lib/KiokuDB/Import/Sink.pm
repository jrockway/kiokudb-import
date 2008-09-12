package KiokuDB::Import::Sink;
use Moose::Role;

use KiokuDB;

use namespace::clean -except => 'meta';

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

sub insert {
    my ($self, @objects) = @_;
    my @uids = $self->connection->store(@objects);
    $self->logger->info("Stored objects as [ @uids ]");
};

1;
