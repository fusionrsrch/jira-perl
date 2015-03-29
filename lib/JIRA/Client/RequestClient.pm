#use MooseX::Declare;

#class JIRA::Client::RequestClient {
package JIRA::Client::RequestClient;

    use Mouse;

    use Data::Dumper;

    use Method::Signatures::Simple name => 'action';

    # Returns the response if the request was successful (HTTP::2xx) and
    # raises a JIRA::HTTPError if it was not successful, with the response
    # attached.
    action request($args) {
        my $response = $self->make_request($args);
        #print Dumper( $response );
        #print $response->code,"\n";
        unless ( $response->code == 200 ) {
            die "\nJIRA::Client::RequestClient: Error ".$response->message." (HTTP ".$response->code.")\n\n";
        }
        return $response;
    }

#    def request(*args)
#      response = make_request(*args)
#      raise HTTPError.new(response) unless response.kind_of?(Net::HTTPSuccess)
#      response
#    end

#}
1;

__PACKAGE__->meta->make_immutable();
