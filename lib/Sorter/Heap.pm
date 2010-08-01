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
    my ($self, $r) = @_;
    return Sorter::Heap::Iterator->new($self->{values}, $r->begin, $r->length);
}

sub _make_heap {
    my ($self, $r) = @_; # r: [first, last)
    for (my $hole = $r->left; !$hole->empty;) {
        $hole->pop_back;
        my $val = $hole->back;
        $self->_adjust_heap($r->left($hole->end), $r->end, $val);
    }
}

sub _adjust_heap {
    my ($self, $r, $bottom, $val, $i) = @_; # r: first, hole
    my $top = $r->end;
    for ($i = $self->_iterator($r)->smaller;
         $i->index < $bottom; $i = $i->smaller) {
        my $g = $i->greater_sibling;
        $i = $g if $self->{pred}->($i->value, $g->value);
        ($r->back, $r->end) = ($i->value, $i->index);
    }
    if ($i->index == $bottom) {
        ($r->back, $r->end) = ($r->left($bottom)->back(1), $bottom-1);
    }
    $self->_push_heap($r, $top, $val);
}

sub _push_heap {
    my ($self, $r, $top, $val, $i) = @_; # r: first, hole
    for (($i, $r) = ($self->_iterator($r)->parent, $r->right($top));
         !$r->empty && $self->{pred}->($i->value, $val); $i = $i->parent) {
        ($r->back, $r->end) = ($i->value, $i->index);
    }
    $r->back = $val;
}

sub _pop_heap {
    my ($self, $r) = @_; # r: [first, last)
    if (1 < $r->length) {
        my $val = $r->back(1);
        $r->back(1) = $r->front;
        $self->_adjust_heap($r->left($r->begin), $r->end-1, $val);
    }
}

package Sorter::Heap::Iterator;

sub new {
    my ($class, $values, $begin, $i) = @_;
    return bless { v => $values, b => $begin, i => $i }, $class;
}

sub clone {
    my ($self, $i) = @_;
    return __PACKAGE__->new($self->{v}, $self->{b}, $i);
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
    return $self->clone($self->_smaller);
}

sub greater {
    my $self = shift;
    return $self->clone($self->_greater-1);
}

sub smaller_sibling {
    my $self = shift;
    return $self->clone($self->{i}+1);
}

sub greater_sibling {
    my $self = shift;
    return $self->clone($self->{i}-1);
}

sub parent {
    my $self = shift;
    return $self->clone($self->_parent);
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
