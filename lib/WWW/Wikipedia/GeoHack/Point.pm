package WWW::Wikipedia::GeoHack::Point;
use strict;
use warnings;
use Geo::Coordinates::DecimalDegrees;
use Class::Accessor::Lite (
    new => 0,
    ro  => [qw[pagename region language type]],
);

sub new {
    my ($class, %param) = @_;
    for my $key (qw/latitude longitude/) {
        my @dms = grep {defined $_} @{$param{$key}};
        my $dmsparts = scalar(@dms); 
        $param{$key} = [
            map {0+ $_} 
            $dmsparts == 1 ? (decimal2dms($dms[0]))[0..2] : 
            $dmsparts == 2 ? (@dms, 0) :
            @dms[0..2]
        ];
        
    }
    $param{type} ||= '';
    bless {%param}, $class; 
}

sub latitude  { shift->_position('latitude') }
sub longitude { shift->_position('longitude') }

sub _position {
    my ($self, $key) = @_;
    wantarray ? @{$self->{$key}} : dms2decimal(@{$self->{$key}});
}

sub dms {
    my $self = shift;
    my @lat = $self->latitude;
    my @lon = $self->longitude;
    ([@lat], [@lon]);
}

sub decimal {
    my $self = shift;
    my $lat = $self->latitude;
    my $lon = $self->longitude;
    ($lat, $lon);
}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::Wikipedia::GeoHack::Point - Coordinates data of WWW::Wikipedia::GeoHack 

=head1 SYNOPSIS

    use utf8;
    use WWW::Wikipedia::GeoHack;
    my $geo = WWW::Wikipedia::GeoHack->new(lang => 'ja');
    my @points = $geo->fetch('渋谷ヒカリエ');
    my ($lat, $lon) = $points[0]->decimal;
    printf "%s N / %s E\n", $lat, $lon;


=head1 DESCRIPTION

WWW::Wikipedia::GeoHack::Point is a coordinates data class of WWW::Wikipedia::GeoHack. 

=head1 ATTRIBUTES

=over 4 

=item pagename

=item region

=item language

=item type  

=back 

=head1 METHODS

=head2 latitude / longitude

    my $lat    = $point->latitude; ## => '35.6589444444444'
    my @dmslat = $point->latitude; ## => [35, 39, 32.2]

Returns latitude / longitude. 

If wantarray is true, return values as dms format. Otherwise, return a value in decimal format.  

=head2 decimal / dms

    my ($lat, $lon) = $point->decimal; ## => ('35.6589444444444', '139.703416666667')
    my ($lat, $lon) = $point->dms;     ## => ([35, 39, 32.2], [139, 42, 12.3])

Returns latitude and longitude in specified format (dms or decimal).

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

