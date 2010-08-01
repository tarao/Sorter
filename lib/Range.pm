package Range;
use strict;
use warnings;

sub new {
    my ($class, $values, $b, $e) = @_;
    $b = 0 unless defined($b);
    $e = 0 + @$values unless defined($e);
    return bless { b => $b, e => $e, values => $values }, $class;
}

sub valid {
    my $self = shift;
    return $self->{b} <= $self->{e};
}

sub empty {
    return shift->length <= 0;
}

sub length {
    my $self = shift;
    return $self->{e} - $self->{b};
}

sub begin : lvalue {
    shift->{b};
}

sub front : lvalue {
    my ($self, $i) = @_;
    $self->{values}->[$self->{b} + ($i || 0)];
}

sub pop_front {
    shift->{b}++;
}

sub end : lvalue {
    shift->{e};
}

sub back : lvalue {
    my ($self, $i) = @_;
    $self->{values}->[$self->{e} - ($i || 0)];
}

sub pop_back {
    shift->{e}--;
}

sub mid {
    my ($self, $mid) = @_;
    $mid = $self->begin + ($self->length >> 1) unless defined($mid);
    return $mid;
}

sub left {
    my ($self, $mid) = @_;
    return $self->clone($self->{b}, $self->mid($mid));
}

sub right {
    my ($self, $mid) = @_;
    return $self->clone($self->mid($mid));
}

sub split {
    my ($self, $mid) = @_;
    return ($self->left($mid), $self->right($mid));
}

sub clone {
    my ($self, $b, $e) = @_;
    $b = $self->{b} unless defined($b);
    $e = $self->{e} unless defined($e);
    return __PACKAGE__->new($self->{values}, $b, $e);
}

1;
__END__
