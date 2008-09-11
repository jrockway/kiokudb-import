package KiokuDB::Import::Source::IDs;
use Moose::Role;

around load => sub {
    my ($next, $self, $object) = @_;
    if( !blessed $object ) {
        delete $object->{_ignore};
        $self->connection->live_objects->insert(%$object);
        $self->store(values %$object);
    }
    else {
        $self->$next($object);
    }
};

1;
