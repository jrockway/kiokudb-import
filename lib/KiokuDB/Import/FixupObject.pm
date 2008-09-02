package KiokuDB::Import::FixupObject;
use strict;
use warnings;
use Carp qw(confess);
use Scalar::Util qw(reftype);
use Data::Visitor::Callback;
use Data::Structure::Util qw(circular_off);
use Class::MOP;

use Sub::Exporter -setup => {
    exports => [ 'fixup_object' ],
};

sub fixup_object {
    my $obj = shift;
    my $new = Data::Visitor::Callback->new(
	object => sub {
            my ( $v, $obj ) = @_;

            my $class = ref $obj;
            _make_package_exist( ref $obj );

            if ( my $meta = Class::MOP::get_metaclass_by_name($class) ) {
                my $instance = $meta->get_meta_instance->create_instance;
                $v->_register_mapping( $obj => $instance );

                my $args = { $v->visit(%$obj) };

                my $new = $meta->new_object(%$args, __INSTANCE__ => $instance);

                $new->BUILDALL($args) if $new->can("BUILDALL");

                return $new;
            }

            return $v->visit_ref($obj);
        },
    )->visit($obj);

    return $new;
}

sub _make_package_exist {
    # XXX: cut-n-pasted from Class::MOP::load_class

    my $class = shift;

    if (ref($class) || !defined($class) || !length($class)) {
        my $display = defined($class) ? $class : 'undef';
        confess "Invalid class name ($display)";
    }

    # if the class is not already loaded in the symbol table..
    unless (Class::MOP::is_class_loaded($class)) {
        # require it
        my $file = $class . '.pm';
        $file =~ s{::}{/}g;
        eval { CORE::require($file) };
        confess "Could not load class ($class) because : $@" if $@;
    }

}

1;
