package WebService::ConstructorIO;

use 5.006;
use strict;
use warnings;
use Moo;
with 'WebService::Client';
use Carp;
use Method::Signatures;

=head1 NAME

WebService::ConstructorIO - A Perl client for the Constructor.io API. Constructor.io provides a lightning-fast, typo-tolerant autocomplete service that ranks your users' queries by popularity to let them find what they're looking for as quickly as possible.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

has api_token        => ( is => 'ro', required => 1 );
has autocomplete_key => ( is => 'ro', required => 1 );
has host             => ( is => 'ro', default => "dev.ac.cnstrc.com" );

has '+base_url'    => ( is => 'ro', default =>
  method {
    #'http://localhost:10000'
    'https://dev.ac.cnstrc.com'
    #'http://192.168.59.103:8006/'
  }
);

=head1 SYNOPSIS

    use WebService::ConstructorIO;

    my $constructorio = WebService::ConstructorIO->new();
    $constructor_io->add(item_name => "item", autocomplete_section => "standard");
    $constructor_io->modify(item_name => "item", new_item_name => "new item",
      autocomplete_section => "standard");
    $constructor_io->remove(item_name => "new item");

=cut

method BUILD(...) {
  $self->ua->default_headers->authorization_basic($self->api_token);
  $self->ua->ssl_opts( verify_hostname => 0 );
}

=head1 METHODS

=head2 add( item_name => $item_name, autocomplete_section => $autocomplete_section [, suggested_score => $suggested_score, keywords => $keywords, url => $url] )

=cut

method add(Str :$item_name!, Str :$autocomplete_section!, Int :$suggested_score, ArrayRef :$keywords, Str :$url) {
  my $response = $self->post("/v1/item?autocomplete_key=" . $self->autocomplete_key, {
    item_name => $item_name,
    autocomplete_section => $autocomplete_section,
    ($suggested_score ? (suggested_score => $suggested_score) : ()),
    ($keywords ? (keywords => $keywords) : ()),
    ($url ? (url => $url) : ()),
  });
}

=head2 remove( item_name => $item_name, autocomplete_section => $autocomplete_section )

=cut

method remove(Str :$item_name!, Str :$autocomplete_section!) {
  my $data = {
    item_name => $item_name,
    autocomplete_section => $autocomplete_section,
  };
  my $path = "/v1/item?autocomplete_key=" . $self->autocomplete_key;

  my $headers = $self->_headers(\%args);
  my $url = $self->_url($path);
  my %content = $self->_content($data, %args);
  my $req = HTTP::Request->new(
      'DELETE', $url, [%$headers], $content{content}
  );
  $self->req($req, %args);
}

=head2 modiy( item_name => $item_name, new_item_name => $new_item_name, autocomplete_section => $autocomplete_section [, suggested_score => $suggested_score, keywords => $keywords, url => $url] )

=cut

method modify(Str :$item_name!, Str :$new_item_name!, Str :$autocomplete_section!, Int :$suggested_score, ArrayRef :$keywords, Str :$url) {
  my $response = $self->put("/v1/item?autocomplete_key=" . $self->autocomplete_key, {
    item_name => $item_name,
    new_item_name => $new_item_name,
    autocomplete_section => $autocomplete_section
  });
}

=head2 track_search( term => $term [, num_results => $num_results ] )

=cut

method track_search(Str :$term!, Str :$num_results) {
  my $response = $self->post("/v1/search?autocomplete_key=" . $self->autocomplete_key, {
    term => $term,
    ($num_results ? (num_results => $num_results) : ()),
  });
}

=head2 track_click_through( term => $term, autocomplete_section => $autocomplete_section [, item => $item ] )

=cut

method track_click_through(Str :$term!, Str :$autocomplete_section!, Str :$item) {
  my $response = $self->post("/v1/search?autocomplete_key=" . $self->autocomplete_key, {
    term => $term,
    autocomplete_section => $autocomplete_section,
    ($item ? (item => $item) : ()),
  });
}

=head2 track_conversion( term => $term, autocomplete_section => $autocomplete_section [, item => $item, revenue => $revenue ] )

=cut

method track_conversion(Str :$term!, Str :$autocomplete_section!, Str :$item, Int :$revenue) {
  my $response = $self->post("/v1/search?autocomplete_key=" . $self->autocomplete_key, {
    term => $term,
    autocomplete_section => $autocomplete_section,
    ($item ? (item => $item) : ()),
    ($revenue ? (revenue => $revenue) : ()),
  });
}

=head1 AUTHOR

Dan McCormick, C<< <dan at constructor.io> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-constructorio at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-ConstructorIO>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::ConstructorIO


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-ConstructorIO>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-ConstructorIO>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-ConstructorIO>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-ConstructorIO/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2015 Constructor.io

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of WebService::ConstructorIO
