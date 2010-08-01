package Sorter::Heap;
use strict;
use warnings;
use base qw/Sorter::Base/;
use Range;

sub sort {
    my $self = shift;
    my $r = Range->new($self->{values});
    $self->_make_heap($r);
    for (; 1 < $r->length; $r->pop_back) {
        $self->_pop_heap($r);
    }
}

sub _iterator {
    my ($self, $begin, $i) = @_;
    return Sorter::Heap::Iterator->new($self->{values}, $begin, $i);
}

sub _make_heap {
    my ($self, $r) = @_;
    my $hole = $r->left;
    while (!$hole->empty) {
        $hole->pop_back;
        my $val = $hole->back;
        $self->_adjust_heap($r->left($hole->end), $r->clone, $val);
    }
}

sub _adjust_heap {
    my ($self, $r, $limit, $val) = @_;
    my $top = $r->end;
    my $i = $self->_iterator($r->begin, $r->length)->smaller;
    for (; $i->index < $limit->end; $i = $i->smaller) {
        my $g = $i->greater_sibling;
        $i = $g if $self->{pred}->($i->value, $g->value);

        $r->back = $i->value;
        $r->end = $i->index;
    }
    if ($i->index == $limit->end) {
        $r->back = $limit->back(1);
        $r->end = $limit->end-1;
    }
    $self->_push_heap($r, $top, $val);
}

sub _push_heap {
    my ($self, $r, $top, $val) = @_;
    for (my $i = $self->_iterator($r->begin, $r->length)->parent;
         $top < $r->end && $self->{pred}->($i->value, $val);
         $i = $i->parent) {
        $r->back = $i->value;
        $r->end = $i->index;
    }
    $r->back = $val;
}

sub _pop_heap {
    my ($self, $r) = @_;
    if (1 < $r->length) {
        my $val = $r->back(1);
        $r->back(1) = $r->front;
        $self->_adjust_heap($r->left($r->begin), $r->left($r->end-1), $val);
    }
}

package Sorter::Heap::Iterator;

sub new {
    my ($class, $values, $begin, $i) = @_;
    return bless { v => $values, b => $begin, i => $i }, $class;
}

sub _smaller {
    return 2 * shift->{i} + 2;
}

sub _greater {
    return shift->_smaller - 1;
}

sub _parent {
    return (shift->{i}-1) >> 1;
}

sub smaller {
    my $self = shift;
    return __PACKAGE__->new($self->{v}, $self->{b}, $self->_smaller);
}

sub greater {
    my $self = shift;
    return __PACKAGE__->new($self->{v}, $self->{b}, $self->_greater-1);
}

sub smaller_sibling {
    my $self = shift;
    return __PACKAGE__->new($self->{v}, $self->{b}, $self->{i}+1);
}

sub greater_sibling {
    my $self = shift;
    return __PACKAGE__->new($self->{v}, $self->{b}, $self->{i}-1);
}

sub parent {
    my $self = shift;
    return __PACKAGE__->new($self->{v}, $self->{b}, $self->_parent);
}

sub index {
    my $self = shift;
    return $self->{b} + $self->{i};
}

sub value {
    my $self = shift;
    return $self->{v}->[$self->index];
}

1;
__END__
