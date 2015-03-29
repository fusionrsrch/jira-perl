#use MooseX::Declare;

#class JIRA::Client::HttpClient extends JIRA::Client::RequestClient {
package JIRA::Client::HttpClient;

    use Mouse; 
    extends 'JIRA::Client::RequestClient';

    use Data::Dumper;

    use LWP::UserAgent;
    use MIME::Base64;

    use Method::Signatures::Simple name => 'action';

    has 'options' => ( isa => 'HashRef', is => 'ro' );

    action BUILD() {

    }

    action make_request($args) {
        my $body        = $args->{args}{body}        || undef; 
        my $headers     = $args->{args}{headers}     || undef; 
        my $http_method = $args->{args}{http_method} || ''; 
        my $path        = $args->{args}{path}        || ''; 

        my $uri  = $self->uri();
        my $host = $uri->host();
        my $port = ':'.$uri->port() || '';
        my $scheme = 'http';

        if ( $self->options->{use_ssl} == 1 ) {
            $scheme = 'https';
        }

        $path = "$scheme://$host".$port.$path;

        print "JIRA::Client::HttpClient->make_request() $http_method | $path \n";
#        my $request = '';
#        my $request = my $issue = $self->http_get( $self->{_jira_url} . "issue/$issue_key"  );
        #return $self->_request($http_method, $path, $body, $headers);
        my $request = HTTP::Request->new( uc($http_method), $path, $headers, $body );
        my $response = $self->basic_auth_http_conn()->request( $request );
        return $response;
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
#

    action basic_auth_http_conn() {
        return $self->http_conn();
    }

    action http_conn() {
        my $http_conn = LWP::UserAgent->new();
        my $username = $self->options->{username} || '';
        my $password = $self->options->{password} || '';

        my $encoded = MIME::Base64::encode_base64( "$username:$password" );
        $http_conn->default_header('Authorization' => "Basic $encoded");
        
        return $http_conn;
    }
#    def http_conn(uri)
#      if @options[:proxy_address]
#          http_class = Net::HTTP::Proxy(@options[:proxy_address], @options[:proxy_port] ? @options[:proxy_port] : 80)
#      else
#          http_class = Net::HTTP
#      end
#      http_conn = http_class.new(uri.host, uri.port)
#      http_conn.use_ssl = @options[:use_ssl]
#      http_conn.verify_mode = @options[:ssl_verify_mode]
#      http_conn
#    end

    action uri() {
        return URI->new( $self->options->{site} );
    }
        
#}
#1;

__PACKAGE__->meta->make_immutable();
