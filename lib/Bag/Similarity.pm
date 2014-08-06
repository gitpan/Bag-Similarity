package Bag::Similarity;

use strict;
use 5.008_005;
our $VERSION = '0.004';

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
  my $self = shift;
  my $tokens1 = shift || [];
  my $tokens2 = shift || [];

  $tokens1 = ref $tokens1 ? $tokens1 : [$tokens1];
  $tokens2 = ref $tokens2 ? $tokens2 : [$tokens2];

  # uncoverable condition false
  return 1 if (!scalar @$tokens1 && !scalar @$tokens2);
  return 0 unless (scalar @$tokens1 && scalar @$tokens2 );
    
  return $self->from_bags(
    $tokens1,
    $tokens2,
  );
}

# overlap is default
sub from_sets {
  my ($self, $set1, $set2) = @_;

  # ( A intersect B ) / min(A,B)  
  return (
    $self->intersection($set1,$set2) / $self->min($set1,$set2)
  );
}

sub intersection { 
  my %uniq;
  @uniq{@{$_[1]}} = ();
  scalar grep { exists $uniq{$_} } @{$_[2]};
}

sub uniq {
  my %uniq; 
  @uniq{@{$_[1]}} = ();
  return keys %uniq; 
}

sub combined_length {
  scalar(@{$_[1]}) + scalar(@{$_[2]});
}

sub min {
  (scalar(@{$_[1]}) < scalar(@{$_[2]}))
    ? scalar(@{$_[1]}) : scalar(@{$_[2]});
}

1;

__END__

=encoding utf-8

=head1 NAME

Bag::Similarity - Similarity measures for bags

=head1 SYNOPSIS

  use Bag::Similarity;

=head1 DESCRIPTION

Bag::Similarity is the base class for similarity measures of bags.

=head1 AUTHOR

Helmut Wollmersdorfer E<lt>helmut.wollmersdorfer@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Helmut Wollmersdorfer

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
