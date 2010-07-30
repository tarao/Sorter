package Sorter;
use strict;
use warnings;

use UNIVERSAL::require;

sub new {
    return bless [], shift;
}

sub get_values {
    return @{scalar(shift)};
}

sub set_values {
    my $self = shift;
    @$self = @_;
}

sub sort {
    my ($self, $args) = @_;

    $args ||= {};
    my $pred = $args->{predicate} || sub{ $_[0] < $_[1] }; # less
    my $algo = $args->{algorithm} || 'quick';

    $algo =~ s/^(.)/\U$1/;
    $algo = join('::', __PACKAGE__, $algo);
    $algo->require or die("Can't load " . $algo);

    $algo->sort($self, $pred);
}

1;
__END__
