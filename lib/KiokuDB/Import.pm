package KiokuDB::Import;
use Moose;
use KiokuDB::Import::FixupObject qw(fixup_object);
use namespace::clean -except => ['meta'];

with 'MooseX::Traits', 'MooseX::LogDispatch';
has '+_trait_namespace' => ( default => __PACKAGE__ );

sub BUILD {
    my $self = shift;
    confess 'You need to consume a trait that "does" KiokuDB::Import::Sink'
      unless $self->does('KiokuDB::Import::Sink');
}

sub load {
    my ( $self, @obj ) = @_;

    $self->insert( $self->fixup( $self->inflate(@obj) ) );
}

sub inflate {
    my ( $self, @obj ) = @_;
    return @obj;
}

sub fixup {
    my ( $self, @obj ) = @_;
    return map { fixup_object($_) } @obj;
}

sub insert {
    my ( $self, $obj ) = @_;
    $self->store($obj);
}

1;

__END__

=head1 NAME

KiokuDB::Import - bulk import objects into a KiokuDB database
