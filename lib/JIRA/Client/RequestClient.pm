use MooseX::Declare;

class JIRA::Client::RequestClient {

    use Data::Dumper;

    use Method::Signatures::Simple name => 'action';

    has 'MAJOR' => ( isa => 'Int', is => 'ro', default => 0 );
    has 'MINOR' => ( isa => 'Int', is => 'ro', default => 1 );
    has 'TINY'  => ( isa => 'Int', is => 'ro', default => 3 );
    has 'PATCH' => ( isa => 'Int', is => 'ro' );

    has 'STRING' => ( isa => 'Str', lazy => 1, is => 'ro', builder => '_build_STRING' );

    action _build_STRING() {
        my @array = ( $self->MAJOR, $self->MINOR, $self->TINY );
        push( @array, $self->PATCH ) if ( $self->PATCH );
        return join( '.', @array );
    }

    # Returns the response if the request was successful (HTTP::2xx) and
    # raises a JIRA::HTTPError if it was not successful, with the response
    # attached.
    action request($args) {
        my $response = $self->make_request($args);
        return $response;
    }

#    def request(*args)
#      response = make_request(*args)
#      raise HTTPError.new(response) unless response.kind_of?(Net::HTTPSuccess)
#      response
#    end

}
