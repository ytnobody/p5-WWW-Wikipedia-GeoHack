package WWW::Wikipedia::GeoHack;
use 5.008001;
use strict;
use warnings;
use WWW::Wikipedia::GeoHack::Point;
use LWP::UserAgent;
use URI::Escape;
use Carp;
use List::Util 'uniq';
use Data::Recursive::Encode;
use Encode;
use Class::Accessor::Lite (
    new => 0,
    ro  => [qw[lang]],
    rw  => [qw[agent]] 
);

our $VERSION = "0.01";

sub new {
    my ($class, %param) = @_;
    my $agent = LWP::UserAgent->new(agent => __PACKAGE__.'/'.$VERSION);
    bless {agent => $agent, %param}, $class;
}

sub url {
    my ($self, $title) = @_;
    sprintf 'http://%s.wikipedia.org/wiki/%s', $self->lang, uri_escape(Encode::encode_utf8($title));
}

sub fetch {
    my ($self, $title) = @_;
    my $url = $self->url($title);
    my $res = $self->agent->get($url);
    croak $res->status_line if !$res->is_success;

    my @matched = $res->content =~ m|href=\"//tools\.wmflabs\.org/geohack/geohack\.php\?(.+?)\"|g;
    map {$self->_parse_params($_)} uniq @matched;
}

sub _parse_params {
    my ($self, $str) = @_;
    my $row  = +{split /(?:=|&amp;)/, uri_unescape($str)};
    my $params = delete $row->{params};
    my @part = map {s/\A_//; $_} split /(?:_N_|_E)/, $params, 3;
    my @opts = split /[:_]/, ($part[2] || '');
    if (scalar(@opts) % 2) {
        push @opts, '';
    }
    my @latitude  = map {m/([0-9\.]+)/; $1;} split /_/, $part[0], 3;
    my @longitude = map {m/([0-9\.]+)/; $1;} split /_/, $part[1], 3;
    my $data = Data::Recursive::Encode->decode_utf8({
        %$row,
        @opts,
        latitude   => [@latitude],
        longitude  => [@longitude],
    });
    WWW::Wikipedia::GeoHack::Point->new(%$data);
}

sub links {
    my ($self, $title) = @_;
    my $url = $self->url($title);
    my $res = $self->agent->get($url);
    croak $res->status_line if !$res->is_success;

    my @matched = $res->content =~ m|href=\"/wiki/(.+?)\"|g;

    return (
        grep {$_ !~ /:/}                            ### Remove special links
        uniq map {(split /\#/, $_)[0]}              ### Unificate page by ankers
        map {Encode::decode_utf8(uri_unescape($_))} ### URI-Escaped to utf8
        uniq @matched
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::Wikipedia::GeoHack - Fetch coordinates from Wikipedia 

=head1 SYNOPSIS

    use utf8;
    use WWW::Wikipedia::GeoHack;
    my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');
    my @points = $geo->fetch('渋谷ヒカリエ');
    my ($lat, $lon) = $points[0]->decimal;
    printf "%s N / %s E\n", $lat, $lon;


=head1 DESCRIPTION

WWW::Wikipedia::GeoHack is a scraper for fetching coordinates data from Wikipedia. 

=head1 ATTRIBUTES

=over 4 

=item lang

A specifier of wikipedia's language.

=item agent 

An instance of LWP::UserAgent. 

=back 

=head1 METHODS

=head2 url

    my $url = $geo->url('ピエリ守山'); ## => https://ja.wikipedia.org/wiki/%E3%83%94%E3%82%A8%E3%83%AA%E5%AE%88%E5%B1%B1

Returns an url of specified entry in wikipedia. 

=head2 fetch

    my @points = $geo->fetch('五稜郭');

Returns WWW::Wikipedia::GeoHack::Point instances as array.

=head2 links

    my @titles = $geo->links('りんかい線');

Returns titles that linked from specified entry in Wikipedia as array.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

