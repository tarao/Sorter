package Sorter::Quick;
use strict;
use warnings;
use base qw/Sorter::Base/;
use Range;

sub sort {
    my $self = shift;
    $self->_sort(Range->new($self->{values}));
}

sub _sort {
    my ($self, $r) = @_;
    while (1 < $r->length) { # semi-recursive implementation of quick sort
        my ($left, $right) = $self->_unguarded_partition($r);
        if ($left->length < $right->length) {
            # right hand side partition is longer:
            # recursively sort shorter left hand side partition
            $self->_sort($left);
            $r = $right; # sort right hand side partition by the loop
        } else {
            # left hand side partition is longer:
            # recursively sort shorter right hand side partition
            $self->_sort($right);
            $r = $left; # sort left hand side partition by the loop
        }
    }
}

sub _unguarded_partition {
    my ($self, $r) = @_;
    my $range = $r->clone;
    my $mid = $r->mid;
    my $pivot = $self->{values}->[$self->_median($r->begin, $mid, $r->end-1)];
    while (1) {
        $r->pop_front while $self->{pred}->($r->front, $pivot);
        $r->pop_back;
        $r->pop_back while $self->{pred}->($pivot, $r->back);
        return $range->split($r->begin) unless $r->valid;

        ($r->front, $r->back) = ($r->back, $r->front);
        $r->pop_front;
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
