package KiokuDB::Import;
use Moose;
use namespace::clean -except => ['meta'];

with qw(KiokuDB::Import::FixupObject);

with 'MooseX::Traits', 'MooseX::LogDispatch';
has '+_trait_namespace' => ( default => __PACKAGE__ );

has '+use_logger_singleton' => ( default => 1 );

sub BUILD {
    my $self = shift;
    confess 'You need to consume a trait that "does" KiokuDB::Import::Sink'
      unless $self->does('KiokuDB::Import::Sink');
}

sub load {
    my ( $self, @obj ) = @_;

	my $s = $self->connection->new_scope;

    $self->insert( $self->fixup( $self->inflate(@obj) ) );
}

sub inflate {
    my ( $self, @obj ) = @_;
    return @obj;
}

1;

__END__

=head1 NAME

KiokuDB::Import - bulk import objects into a KiokuDB database
