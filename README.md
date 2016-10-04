# NAME

WWW::Wikipedia::GeoHack - Fetch coordinates from Wikipedia 

# SYNOPSIS

    use utf8;
    use WWW::Wikipedia::GeoHack;
    my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');
    my @points = $geo->fetch('渋谷ヒカリエ');
    my ($lat, $lon) = $points[0]->decimal;
    printf "%s N / %s E\n", $lat, $lon;

# DESCRIPTION

WWW::Wikipedia::GeoHack is a scraper for fetching coordinates data from Wikipedia. 

# ATTRIBUTES

- lang

    A specifier of wikipedia's language.

- agent 

    An instance of LWP::UserAgent. 

# METHODS

## url

    my $url = $geo->url('ピエリ守山'); ## => https://ja.wikipedia.org/wiki/%E3%83%94%E3%82%A8%E3%83%AA%E5%AE%88%E5%B1%B1

Returns an url of specified entry in wikipedia. 

## fetch

    my @points = $geo->fetch('五稜郭');

Returns WWW::Wikipedia::GeoHack::Point instances as array.

## links

    my @titles = $geo->links('りんかい線');

Returns titles that linked from specified entry in Wikipedia as array.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
