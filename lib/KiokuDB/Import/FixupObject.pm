package KiokuDB::Import::FixupObject;
use Moose::Role;

use Carp qw(confess croak);
use Scalar::Util qw(reftype);
use Data::Visitor::Callback;
use Class::MOP;

use namespace::clean -except => 'meta';

sub fixup {
	my ( $self, @objects ) = @_;

    Data::Visitor::Callback->new(
        object => sub {
            my ( $v, $obj ) = @_;

            my $class = ref $obj;
            _make_package_exist( $class );

            if ( my $meta = Class::MOP::get_metaclass_by_name($class) ) {
                my $instance = $meta->get_meta_instance->create_instance;
                $v->_register_mapping( $obj => $instance );

                my $v = { $v->visit(%$obj) };
                # map (attribute => value) pairs to (init_arg => value) for new

                my @attrs;

                foreach my $name ( keys %$v ) {
                    my $attr = $meta->get_attribute($name)
                        or croak "$class does not have the attribute '$name'";

                    croak "Attr '$name' of class $class does not have an init arg"
                    unless $attr->has_init_arg;

                    push @attrs, $attr;
                }

                my $args = +{ map { $_->init_arg => $v->{$_->name} } @attrs };

                my $new = $meta->new_object(%$args, __INSTANCE__ => $instance);
                $new->BUILDALL($args) if $new->can("BUILDALL");

                return $new;
            } else {
				return $v->visit_ref($obj);
			}
        },
    )->visit(@objects);
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
