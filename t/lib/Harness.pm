package t::lib::Harness;

use Exporter 'import';
use Test::More import => [qw(plan)];
use WebService::ConstructorIO;

our @EXPORT_OK = qw( constructor_io );

sub constructor_io {
    return WebService::ConstructorIO->new(
        api_token => api_token(),
        autocomplete_key => autocomplete_key(),
    )
}

sub api_token { $ENV{CONSTRUCTOR_IO_API_TOKEN} }
sub autocomplete_key { $ENV{CONSTRUCTOR_IO_AUTOCOMPLETE_KEY} }

1;
