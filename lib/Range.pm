package Range;
use strict;
use warnings;

sub new {
    my ($class, $values, $b, $e) = @_;
    $b ||= 0;
    $e ||= 0 + @$values;
    return bless { b => $b, e => $e, values => $values }, $class;
}

sub valid {
    my $self = shift;
    return $self->{b} < $self->{e};
}

sub empty {
    my $self = shift;
    return $self->length <= 0;
}

sub length {
    my $self = shift;
    return $self->{e} - $self->{b} - 1;
}

sub begin {
    return shift->{b};
}

sub front : lvalue {
    my $self = shift;
    $self->{values}->[$self->{b}];
}

sub pop_front {
    shift->{b}++;
}

sub end {
    return shift->{e};
}

sub back : lvalue {
    my $self = shift;
    $self->{values}->[$self->{e}];
}

sub pop_back {
    shift->{e}--;
}

sub split {
    my ($self, $mid) = @_;
    return ($self->clone(undef, $mid), $self->clone($mid));
}

sub clone {
    my ($self, $b, $e) = @_;
    $b = $self->{b} unless defined($b);
    $e = $self->{e} unless defined($e);
    return __PACKAGE__->new($self->{values}, $b, $e);
}

1;
__END__
