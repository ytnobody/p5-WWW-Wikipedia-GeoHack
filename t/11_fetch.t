use strict;
use warnings;
use Test::More;
use WWW::Wikipedia::GeoHack;
use utf8;

my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');

subtest 'Abeno Harukas' => sub {
    my @points = $geo->fetch('あべのハルカス');
    is scalar(@points), 1;
    my $p = $points[0];
    isa_ok $p, 'WWW::Wikipedia::GeoHack::Point';
    is $p->pagename, 'あべのハルカス';
    my ($lat, $lon) = $p->decimal;
    is $lat, '34.6459472222222';                                                                                              
    is $lon, '135.514266666667';
    my ($lats, $lons) = $p->dms;
    is_deeply $lats, [34, 38, 45.41];
    is_deeply $lons, [135, 30, 51.36]; 
};

subtest 'Shibuya Hikarie' => sub {
    my @points = $geo->fetch('渋谷ヒカリエ');
    is scalar(@points), 1;
    my $p = $points[0];
    isa_ok $p, 'WWW::Wikipedia::GeoHack::Point';
    is $p->pagename, '渋谷ヒカリエ';
    my ($lat, $lon) = $p->decimal;
    is $lat, '35.6589444444444';                                                                                              
    is $lon, '139.703416666667';
    my ($lats, $lons) = $p->dms;
    is_deeply $lats, [35, 39, 32.2];
    is_deeply $lons, [139, 42, 12.3]; 
};

done_testing;