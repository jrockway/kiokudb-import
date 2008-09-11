package KiokuDB::Import::Source::IDs;
use Moose::Role;

around insert => sub {
    my ($next, $self, $object) = @_;
    if( !blessed $object ) {
        delete $object->{_ignore};
        $self->connection->live_objects->insert(%$object);
        return $self->$next(values %$object);
    } else {
        return $self->$next($object);
    }
};

1;
