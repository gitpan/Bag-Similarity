package Bag::Similarity::Cosine;

use strict;
use warnings;

use parent 'Bag::Similarity';

our $VERSION = '0.002';

sub from_bags {
  my ($self, $set1, $set2) = @_;
  return $self->_similarity(
	$set1,
	$set2
  );
}

sub _similarity {
  my ( $self, $tokens1,$tokens2 ) = @_;
		
  my $vector1 = $self->make_vector( $tokens1 );
  my $vector2 = $self->make_vector( $tokens2 );

  my $cosine = $self->cosine( 
	$self->normalize($vector1), 
	$self->normalize($vector2) 
  );
  return $cosine;
}

sub make_vector {			
  my ( $self, $tokens ) = @_;
  my %elements;  
  do { $_++ } for @elements{@$tokens};
  return \%elements;
}	

# Assumes both incoming vectors are normalized
sub cosine {
  my ( $self, $vector1, $vector2 ) = @_;
  return $self->dot( $vector1, $vector2 );	# inner product
}

sub norm {
  my $self = shift;
  my $vector = shift;
  my $sum = 0;
  for my $key (keys %$vector) {
    $sum += $vector->{$key} ** 2;
  }
  return sqrt $sum;
}

sub normalize {
  my $self = shift;
  my $vector = shift;
  my $vnorm = $self->norm($vector);

  return $self->div($vector,$vnorm);
}

sub zeros {
  my $self = shift;
  my $count = shift;
  my $vector = [];
  for my $index (0..$count-1) {
    $vector->[$index] = 0;
  }
  return $vector;
}

sub dot {
  my $self = shift;
  my $vector1 = shift;
  my $vector2 = shift;

  my $dotprod = 0;

  for my $key (keys %$vector1) {
    $dotprod += $vector1->{$key} * $vector2->{$key} if ($vector2->{$key});
  }
  return $dotprod;
}


# divides each vector entry by a given divisor
sub div {
  my $self = shift;
  my $vector = shift;
  my $divisor = shift;

  my $vector2 =  {};
  for my $key (keys %$vector) {
    $vector2->{$key} = $vector->{$key} / $divisor;
  }
  return $vector2;
}


1;


__END__

=head1 NAME

Bag::Similarity::Cosine - Cosine similarity for sets

=head1 SYNOPSIS

 use Bag::Similarity::Cosine;
 
 # object method
 my $cosine = Bag::Similarity::Cosine->new;
 my $similarity = $cosine->similarity('Photographer','Fotograf');
 
 # class method
 my $cosine = 'Bag::Similarity::Cosine';
 my $similarity = $cosine->similarity('Photographer','Fotograf');
 
 # from 2-grams
 my $width = 2;
 my $similarity = $cosine->similarity('Photographer','Fotograf',$width);
 
 # from arrayref of tokens
 my $similarity = $cosine->similarity(['a','b'],['b']);
 
 # from hashref of features
 my $bird = {
   wings    => true,
   eyes     => true,
   feathers => true,
   hairs    => false,
   legs     => true,
   arms     => false,
 };
 my $mammal = {
   wings    => false,
   eyes     => true,
   feathers => false,
   hairs    => true,
   legs     => true,
   arms     => true, 
 };
 my $similarity = $cosine->similarity($bird,$mammal);
 
 # from arrayref sets
 my $bird = [qw(
   wings
   eyes
   feathers
   legs
 )];
 my $mammal = [qw(
   eyes
   hairs
   legs
   arms
 )];
 my $similarity = $cosine->from_sets($bird,$mammal);

=head1 DESCRIPTION

=head2 Cosine similarity

A intersection B / (sqrt(A) * sqrt(B))


=head1 METHODS

L<Bag::Similarity::Cosine> inherits all methods from L<Bag::Similarity> and implements the
following new ones.

=head2 from_sets

  my $similarity = $object->from_sets(['a'],['b']);
 
This method expects two arrayrefs of strings as parameters. The parameters are not checked, thus can lead to funny results or uncatched divisions by zero.
 
If you want to use this method directly, you should take care that the elements are unique. Also you should catch the situation where one of the arrayrefs is empty (similarity is 0), or both are empty (similarity is 1).

=head1 SOURCE REPOSITORY

L<http://github.com/wollmers/Bag-Similarity>

=head1 AUTHOR

Helmut Wollmersdorfer, E<lt>helmut.wollmersdorfer@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013-2014 by Helmut Wollmersdorfer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

