use strict;
use warnings;
use Test::More;
use WWW::Wikipedia::GeoHack;

my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');

my %patterns = (
    "St.Luke's Garden"    => 'language=ja&amp;pagename=%E8%81%96%E8%B7%AF%E5%8A%A0%E3%82%AC%E3%83%BC%E3%83%87%E3%83%B3&amp;params=35.667418___N_139.778671___E_type:landmark_region:JP',
    "Chicago"             => 'language=ja&amp;pagename=%E3%82%B7%E3%82%AB%E3%82%B4&amp;params=41_54_N_87_39_W_',
    "Bank of America"     => 'language=ja&amp;pagename=%E3%83%90%E3%83%B3%E3%82%AF%E3%83%BB%E3%82%AA%E3%83%96%E3%83%BB%E3%82%A2%E3%83%A1%E3%83%AA%E3%82%AB%E3%83%BB%E3%82%BF%E3%83%AF%E3%83%BC_%28%E3%83%8B%E3%83%A5%E3%83%BC%E3%83%A8%E3%83%BC%E3%82%AF%29&amp;params=40.755278_N_73.984167_W_',
    "Ryutsu Keizai Univ." => 'language=ja&amp;pagename=%E6%B5%81%E9%80%9A%E7%B5%8C%E6%B8%88%E5%A4%A7%E5%AD%A6&amp;params=35.917567___N_140.19006___E_type:edu_region:JP',
    "Gamagoori City"      => 'language=ja&amp;pagename=%E8%92%B2%E9%83%A1%E5%B8%82&amp;params=34_50__N_137_13__E_region:JP_type:city',
);

for my $case (keys %patterns) {
    my $input = $patterns{$case};
    my $point = $geo->_parse_params($input);
    isa_ok $point, 'WWW::Wikipedia::GeoHack::Point';
    for my $latlon (qw/latitude longitude/) {
        is scalar(@{$point->{$latlon}}), 3, "$case $latlon num of items is 3";
        for my $i (0 .. $#{$point->{$latlon}}) {
            like $point->{$latlon}[$i], qr/^[0-9\.]+$/, "$case $latlon $i, ".$point->{$latlon}[$i];
        }
    }
}


done_testing;