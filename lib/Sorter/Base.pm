package Sorter::Base;
use strict;
use warnings;

sub new {
    my ($class, $array, $pred) = @_;
    return bless { values => $array, pred => $pred }, $class;
}

1;
__END__
