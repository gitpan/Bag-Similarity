package Bag::Similarity;

use strict;
use warnings;

use 5.008_005;
our $VERSION = '0.011';

use Carp 'croak';

sub new {
  my $class = shift;
  # uncoverable condition false
  bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
}

sub similarity {
  my ($self, $any1, $any2, $width) = @_;

  return $self->from_tokens(
    $self->_any($any1,$width),
    $self->_any($any2,$width)
  );
}

sub _any {
  my ($self, $any, $width) = @_;
	
  if (ref($any) eq 'ARRAY') {
    return $any;
  }
  elsif (ref($any) eq 'HASH') {
	return [grep { $any->{$_} } keys %$any];
  }
  elsif (ref($any)) {
   return [];
  }
  else {
    return [$self->ngrams($any,$width)];
  }
}

sub ngrams {
  my ($self, $word, $width) = @_;

  $width = 1 unless defined $width;
  $word ||= '';

  my @ngrams;
  return @ngrams 
    unless ($width =~ m/^[1-9][0-9]*$/x && $width <= length($word));

  for my $i (0..length($word)-$width) {
    my $ngram = substr $word,$i,$width;
    push @ngrams,$ngram;
  }

  return @ngrams;
}

sub from_tokens {
  my ($self, $tokens1, $tokens2) = @_;

  # uncoverable condition false
  return 1 if (!scalar @$tokens1 && !scalar @$tokens2);
  return 0 unless (scalar @$tokens1 && scalar @$tokens2 );
    
  return $self->from_bags(
    $tokens1,
    $tokens2,
  );
}

sub from_bags { croak 'Method "from_bags" not implemented in subclass' }

1;

__END__

=encoding utf-8

=head1 NAME

Bag::Similarity - Similarity measures for bags

=for html
<a href="https://travis-ci.org/wollmers/Bag-Similarity"><img src="https://travis-ci.org/wollmers/Bag-Similarity.png" alt="Bag-Similarity"></a>
<a href='https://coveralls.io/r/wollmers/Bag-Similarity?branch=master'><img src='https://coveralls.io/repos/wollmers/Bag-Similarity/badge.png?branch=master' alt='Coverage Status' /></a>

=head1 SYNOPSIS

  use Bag::Similarity;

=head1 DESCRIPTION

Bag::Similarity is the base class for similarity measures of bags.

=head1 AUTHOR

Helmut Wollmersdorfer E<lt>helmut.wollmersdorfer@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014 Helmut Wollmersdorfer

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
