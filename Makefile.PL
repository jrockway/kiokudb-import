use inc::Module::Install;

name 'KiokuDB-Import';
all_from 'lib/KiokuDB/Import.pm';

build_requires 'Test::More';
build_requires 'ok';

WriteAll();
