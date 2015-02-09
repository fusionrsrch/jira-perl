use MooseX::Declare;

class JIRA::Client::HttpClient extends JIRA::Client::RequestClient {

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

    action make_request($http_method, $path, $body, $headers) {
        print "JIRA::Client::HttpClient->make_request() $http_method | $path | $body | $headers\n";
        my $request = '';
    }
#
#   def make_request(http_method, path, body='', headers={})
#      request = Net::HTTP.const_get(http_method.to_s.capitalize).new(path, headers)
#      request.body = body unless body.nil?
#      add_cookies(request) if options[:use_cookies]
#      request.basic_auth(@options[:username], @options[:password])
#      response = basic_auth_http_conn.request(request)
#      store_cookies(response) if options[:use_cookies]
#      response
#    end

        
}
