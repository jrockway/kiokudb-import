package KiokuDB::Import::Source::Directory;
use Moose::Role;
use MooseX::Types::Path::Class qw(Dir);
use File::Next;

around inflate => sub {
    my ($next, $self, $root) = @_;

    if ( !blessed($root) or $root->isa("Path::Class::Dir") ) {
        $self->logger->info("Loading directory $root");
        my $files = File::Next::files( 
            { 
                file_filter    => sub { !/^\./ },
                descend_filter => sub { !/^\./ },
            },
            $root 
        );

        my @ret;

        while( defined( my $file = $files->() ) ){
            push @ret, $self->$next($file);
        }

        return @ret;
    } else {
        return $root;
    }
};

1;
