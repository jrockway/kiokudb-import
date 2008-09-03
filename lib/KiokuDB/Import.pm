package KiokuDB::Import;
use Moose;
use KiokuDB::Import::FixupObject qw(fixup_object);
use namespace::clean -except => ['meta'];

with 'MooseX::Traits', 'MooseX::LogDispatch';
has '+_trait_namespace' => ( default => __PACKAGE__ );

sub load {
    my ($self, $obj) = @_;
    return $self->store(fixup_object($obj));
}

sub store {}

1;

__END__

=head1 NAME

KiokuDB::Import - bulk import objects into a KiokuDB database
