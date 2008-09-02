use inc::Module::Install;

name 'KiokuDB-Import';
all_from 'lib/KiokuDB/Import.pm';

requires 'Class::MOP';
requires 'Data::Structure::Util';
requires 'Data::Visitor::Callback';
requires 'Moose';
requires 'Scalar::Util';
requires 'YAML';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
