requires 'perl', '5.008001';
requires 'LWP::UserAgent';
requires 'Class::Accessor::Lite';
requires 'URI::Escape';
requires 'Carp';
requires 'List::Util', '>= 1.45';
requires 'Geo::Coordinates::DecimalDegrees';
requires 'Data::Recursive::Encode';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

