package Sorter::Heap;
use strict;
use warnings;
use base qw/Sorter::Base/;

sub sort {
    my $self = shift;
    my ($first, $last) = (0, scalar(@{$self->{values}}));
    $self->_make_heap($first, $last);
    for (; 1 < $last-$first; --$last) {
        $self->_pop_heap($first, $last);
    }
}

sub _make_heap {
    my ($self, $first, $last) = @_;
    my $bottom = $last-$first;
    my $hole = $bottom >> 1;
    while (0 < $hole) {
        --$hole;
        my $val = $self->{values}->[$first+$hole];
        $self->_adjust_heap($first, $hole, $bottom, $val);
    }
}

sub _adjust_heap {
    my ($self, $first, $hole, $bottom, $val) = @_;
    my $top = $hole;
    my $i = 2*$hole+2;
    for (; $i < $bottom; $i = 2*$i+2) {
        --$i if ($self->{pred}->($self->{values}->[$first+$i],
                                 $self->{values}->[$first+$i-1]));
        $self->{values}->[$first+$hole] = $self->{values}->[$first+$i];
        $hole = $i;
    }
    if ($i == $bottom) {
        $self->{values}->[$first+$hole] = $self->{values}->[$first+$bottom-1];
        $hole = $bottom-1;
    }
    $self->_push_heap($first, $hole, $top, $val);
}

sub _push_heap {
    my ($self, $first, $hole, $top, $val) = @_;
    for (my $i = ($hole-1)>>1;
         $top < $hole && $self->{pred}->($self->{values}->[$first+$i], $val);
         $i = ($hole-1)>>1) {
        $self->{values}->[$first+$hole] = $self->{values}->[$first+$i];
        $hole = $i;
    }
    $self->{values}->[$first+$hole] = $val;
}

sub _pop_heap {
    my ($self, $first, $last) = @_;
    if (1 < $last-$first) {
        my $val = $self->{values}->[$last-1];
        $self->{values}->[$last-1] = $self->{values}->[$first];
        $self->_adjust_heap($first, 0, $last-1-$first, $val);
    }
}

1;
__END__
