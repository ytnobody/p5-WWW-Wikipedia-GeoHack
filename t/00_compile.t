use strict;
use Test::More 0.98;

use_ok $_ for qw(
    WWW::Wikipedia::GeoHack
);

my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');
isa_ok $geo, 'WWW::Wikipedia::GeoHack';

done_testing;

