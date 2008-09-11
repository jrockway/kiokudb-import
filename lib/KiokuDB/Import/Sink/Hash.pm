package KiokuDB::Import::Sink::Hash;
use Moose::Role;
use KiokuDB::Backend::Hash;

with 'KiokuDB::Import::Sink';

sub _build_backend {
	KiokuDB::Backend::Hash->new(),
}

1;
