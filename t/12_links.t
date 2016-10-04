use strict;
use warnings;
use Test::More;
use WWW::Wikipedia::GeoHack;
use utf8;

my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');

subtest 'Japan High Buildings' => sub {
    my @links = $geo->links('日本の超高層建築物');
    is scalar(grep {/\A東京タワー\z/} @links), 1;
    is scalar(grep {/\Aあべのハルカス\z/} @links), 1;
    is scalar(grep {/\A渋谷ヒカリエ\z/} @links), 0;
    is scalar(grep {/\A東京スカイツリー\z/} @links), 1;
};

done_testing;