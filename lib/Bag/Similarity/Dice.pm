package Bag::Similarity::Dice;

use strict;
use warnings;

use parent 'Bag::Similarity';

our $VERSION = '0.014';

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

  my $dot = $self->dot( 
	$vector1, 
	$vector2 
  );
  my $dice = 2 * $dot / (
    $self->norm($vector1) ** 2 
    + $self->norm($vector2) ** 2
  );
  return $dice;
}

sub make_vector {			
  my ( $self, $tokens ) = @_;
  my %elements;  
  do { $_++ } for @elements{@$tokens};
  return \%elements;
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

1;


__END__

=head1 NAME

Bag::Similarity::Dice - Dice similarity for bags

=head1 SYNOPSIS

 use Bag::Similarity::Dice;
 
 # object method
 my $dice = Bag::Similarity::Dice->new;
 my $similarity = $dice->similarity('Photographer','Fotograf');
 
 
=head1 DESCRIPTION

=head2 Dice similarity

2 * dot(A,B) / (norm(A) ** 2 + norm(B) ** 2) 


=head1 METHODS

L<Bag::Similarity::Cosine> inherits all methods from L<Bag::Similarity> and implements the
following new ones.

=head2 from_bags

  my $similarity = $object->from_bags(['a'],['b']);
 
This method expects two arrayrefs of strings as parameters. The parameters are not checked, thus can lead to funny results or uncatched divisions by zero.
 
If you want to use this method directly, you should catch the situation where one of the arrayrefs is empty (similarity is 0), or both are empty (similarity is 1).

=head1 SOURCE REPOSITORY

L<http://github.com/wollmers/Bag-Similarity>

=head1 AUTHOR

Helmut Wollmersdorfer, E<lt>helmut.wollmersdorfer@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Helmut Wollmersdorfer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

