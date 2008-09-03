package KiokuDB::Import::Source::Directory;
use Moose::Role;
use MooseX::Types::Path::Class qw(Dir);
use File::Next;

around load => sub {
    my ($next, $self, $root) = @_;
    $self->logger->info("Loading directory $root");
    my $files = File::Next::files( $root );
    while( defined( my $file = $files->() ) ){
        $self->$next($file);
    }
};

1;
