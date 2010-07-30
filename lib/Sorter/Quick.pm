package Sorter::Quick;
use strict;
use warnings;
use base qw/Sorter::Base/;

sub sort {
    my $self = shift;
    $self->_sort(0, scalar(@{$self->{values}}));
}

sub _sort {
    my ($self, $first, $last) = @_;
    while (1 < $last - $first) { # semi-recursive implementation of quick sort
        my $cut = $self->_unguarded_partition($first, $last);
        if ($cut - $first < $last - $cut) {
            # right hand side partition is longer:
            # recursively sort shorter left hand side partition
            $self->_sort($first, $cut);
            $first = $cut;
        } else {
            # left hand side partition is longer:
            # recursively sort shorter right hand side partition
            $self->_sort($cut, $last);
            $last = $cut;
        }
    }
}

sub _unguarded_partition {
    my ($self, $first, $last) = @_;
    my $mid = $first + (($last - $first)>>1);
    my $pivot = $self->{values}->[$self->_median($first, $mid, $last-1)];
    while (1) {
        ++$first while ($self->{pred}->($self->{values}->[$first], $pivot));
        --$last;
        --$last while ($self->{pred}->($pivot, $self->{values}->[$last]));
        return $first unless $first < $last;

        ($self->{values}->[$first], $self->{values}->[$last])
            = ($self->{values}->[$last], $self->{values}->[$first]);
        ++$first;
    }
}

sub _median {
    my ($self, $first, $mid, $last) = @_;
    if (40 < $last - $first) {
        my $step = ($last - $first + 1) >> 3;
        return $self->_med3(
            $self->_med3($first,        $first+$step, $first+2*$step),
            $self->_med3($mid-$step,    $mid,         $mid+$step),
            $self->_med3($last-2*$step, $last-$step,  $last));
    } else {
        return $self->_med3($first, $mid, $last);
    }
}

sub _med3 {
    my ($self, $first, $mid, $last) = @_;
    my ($v, $p) = ($self->{values}, $self->{pred});
    return $p->($v->[$mid], $v->[$first]) ?
        ($p->($v->[$first], $v->[$last]) ? $first :
                  ($p->($v->[$mid], $v->[$last]) ? $last : $mid)) :
        ($p->($v->[$mid], $v->[$last]) ? $mid :
                  ($p->($v->[$first], $v->[$last]) ? $last : $first));
}

1;
__END__
