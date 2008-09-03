package KiokuDB::Import::Script::ImportYAMLDirectory;
use Moose;
use KiokuDB::Import;
use MooseX::Types::Path::Class qw(Dir);
with 'MooseX::Getopt';

has fixtures => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

has database => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);


sub run {
    my ($self) = @_;
    my $dir = $self->fixtures;
    confess "fixture source '$dir' does not exist" unless -d $dir;

    my $source = KiokuDB::Import->new_with_traits(
        traits  => [qw/Source::YAML Source::Directory Sink::JSPON/],
        storage => $self->database,
    );

    $source->load($dir);
}

1;
