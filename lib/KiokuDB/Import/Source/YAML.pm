package KiokuDB::Import::Source::YAML;
use Moose::Role;
use YAML::XS;

around load => sub {
    my ($next, $self, $file) = @_;
    $self->logger->info("Loading file $file");
    return $self->$next(YAML::XS::LoadFile($file));
};

1;
