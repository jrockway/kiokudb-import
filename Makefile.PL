use inc::Module::Install;

name 'KiokuDB-Import';
all_from 'lib/KiokuDB/Import.pm';

requires 'Class::MOP';
requires 'Data::Structure::Util';
requires 'Data::Visitor::Callback';
requires 'File::Next';
requires 'Moose';
requires 'Moose::Role';
requires 'MooseX::Getopt';
requires 'MooseX::Traits';
requires 'MooseX::Types::Path::Class';
requires 'Scalar::Util';
requires 'YAML::XS';
requires 'namespace::clean';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
