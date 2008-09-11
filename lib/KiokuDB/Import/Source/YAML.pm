package KiokuDB::Import::Source::YAML;
use Moose::Role;
use YAML::XS;

around inflate => sub {
    my ($next, $self, $thingy) = @_;

    if ( !blessed($thingy) or $thingy->isa("Path::Class::File") ) {
        $self->logger->info("Loading file $thingy");
        $thingy = YAML::XS::LoadFile($thingy);
    }

    return $self->$next($thingy);
};

1;
